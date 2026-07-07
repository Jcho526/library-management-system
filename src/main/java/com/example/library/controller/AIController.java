package com.example.library.controller;

import com.example.library.entity.AiLog;
import com.example.library.entity.Book;
import com.example.library.entity.BorrowRecord;
import com.example.library.entity.User;
import com.example.library.service.AiLogService;
import com.example.library.service.BookService;
import com.example.library.service.BorrowRecordService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/ai")
@CrossOrigin(origins = "*")
public class AIController {

    private final RestTemplate restTemplate;
    private final BorrowRecordService borrowRecordService;
    private final BookService bookService;
    private final AiLogService aiLogService;

    @Value("${deepseek.api.key}")
    private String apiKey;

    @Value("${deepseek.api.base-url}")
    private String baseUrl;

    @Value("${deepseek.api.model}")
    private String model;

    @Autowired
    public AIController(RestTemplate restTemplate,
                        BorrowRecordService borrowRecordService,
                        BookService bookService,
                        AiLogService aiLogService) {
        this.restTemplate = restTemplate;
        this.borrowRecordService = borrowRecordService;
        this.bookService = bookService;
        this.aiLogService = aiLogService;
    }

    /**
     * 功能 A：AI 智能图书摘要生成
     */
    @PostMapping("/summary")
    public ResponseEntity<Map<String, Object>> generateSummary(@RequestBody Map<String, String> request) {
        Map<String, Object> response = new HashMap<>();
        String bookName = request.get("bookName");
        String author = request.get("author");

        if (bookName == null || bookName.trim().isEmpty()) {
            response.put("success", false);
            response.put("message", "书名不能为空");
            return ResponseEntity.badRequest().body(response);
        }

        try {
            String prompt;
            if (author != null && !author.trim().isEmpty()) {
                prompt = String.format("你是一个图书管理专家，请为《%s》（作者：%s）写一段不超过100字的内容摘要。",
                        bookName, author);
            } else {
                prompt = String.format("你是一个图书管理专家，请为《%s》写一段不超过100字的内容摘要。",
                        bookName);
            }

            String summary = callDeepSeek(prompt);
            response.put("success", true);
            response.put("summary", summary);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "AI摘要生成失败：" + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    /**
     * 功能 B：智能图书问答客服助手
     */
    @PostMapping("/chat")
    public ResponseEntity<Map<String, Object>> chat(@RequestBody Map<String, Object> request,
                                                     HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            response.put("success", false);
            response.put("message", "未登录");
            return ResponseEntity.status(401).body(response);
        }

        String message = (String) request.get("message");
        if (message == null || message.trim().isEmpty()) {
            response.put("success", false);
            response.put("message", "消息不能为空");
            return ResponseEntity.badRequest().body(response);
        }

        try {
            // 保存用户消息到日志
            AiLog userLog = new AiLog();
            userLog.setUserId(user.getId());
            userLog.setRole("user");
            userLog.setContent(message);
            aiLogService.saveLog(userLog);

            // 获取用户借阅历史
            List<BorrowRecord> records = borrowRecordService.findByUserId(user.getId());
            StringBuilder history = new StringBuilder();
            if (records != null && !records.isEmpty()) {
                for (BorrowRecord r : records) {
                    history.append(String.format("- 《%s》 借阅时间：%s",
                            r.getBookName() != null ? r.getBookName() : "未知",
                            r.getBorrowTime() != null ? r.getBorrowTime().toString() : "未知"));
                    if (r.getStatus() != null && r.getStatus() == 1) {
                        history.append("（已归还）");
                    }
                    history.append("\n");
                }
            } else {
                history.append("暂无借阅记录");
            }

            // 获取馆藏图书列表
            List<Book> allBooks = bookService.findAll();
            StringBuilder catalog = new StringBuilder();
            if (allBooks != null && !allBooks.isEmpty()) {
                for (Book b : allBooks) {
                    catalog.append(String.format("- 《%s》（作者：%s，ISBN：%s，库存：%d）\n",
                            b.getBookName(),
                            b.getAuthor() != null ? b.getAuthor() : "未知",
                            b.getIsbn() != null ? b.getIsbn() : "",
                            b.getStock() != null ? b.getStock() : 0));
                }
            }

            String prompt = String.format(
                    "用户问：%s。\n" +
                    "请基于以下本地规则回答：本图书馆借期30天，逾期扣除信用分。\n" +
                    "若用户要求推荐书籍，请只推荐下面馆藏列表中实际存在的书，并注明书名和作者。\n" +
                    "用户的借阅历史：\n%s\n" +
                    "当前图书馆馆藏图书：\n%s",
                    message, history.toString(), catalog.toString()
            );

            String answer = callDeepSeek(prompt);

            // 保存 AI 回复到日志
            AiLog assistantLog = new AiLog();
            assistantLog.setUserId(user.getId());
            assistantLog.setRole("assistant");
            assistantLog.setContent(answer);
            aiLogService.saveLog(assistantLog);

            response.put("success", true);
            response.put("answer", answer);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "AI回复失败：" + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    /**
     * 调用 DeepSeek API（OpenAI 兼容接口）
     */
    private String callDeepSeek(String userPrompt) {
        String url = baseUrl + "/chat/completions";

        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("model", model);
        requestBody.put("messages", List.of(
                Map.of("role", "system", "content", "你是一个专业的图书管理助手，回答应简洁、准确、有帮助。"),
                Map.of("role", "user", "content", userPrompt)
        ));
        requestBody.put("max_tokens", 500);
        requestBody.put("temperature", 0.7);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBearerAuth(apiKey);

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);

        ResponseEntity<Map> result = restTemplate.postForEntity(url, entity, Map.class);

        if (result.getBody() != null && result.getBody().containsKey("choices")) {
            List<Map<String, Object>> choices = (List<Map<String, Object>>) result.getBody().get("choices");
            if (choices != null && !choices.isEmpty()) {
                Map<String, Object> choice = choices.get(0);
                Map<String, Object> messageObj = (Map<String, Object>) choice.get("message");
                if (messageObj != null) {
                    return (String) messageObj.get("content");
                }
            }
        }
        throw new RuntimeException("DeepSeek API 返回数据异常");
    }
}