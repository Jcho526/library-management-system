package com.example.library.controller;

import com.example.library.entity.Book;
import com.example.library.service.BookService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/books")
@CrossOrigin(origins = "*")
public class BookController {

    private final BookService bookService;

    @Autowired
    public BookController(BookService bookService) {
        this.bookService = bookService;
    }

    @GetMapping
    public ResponseEntity<List<Book>> getAllBooks() {
        List<Book> books = bookService.findAll();
        return ResponseEntity.ok(books);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Book> getBookById(@PathVariable Long id) {
        Book book = bookService.findById(id);
        if (book == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(book);
    }

    @PostMapping
    public ResponseEntity<Map<String, Object>> createBook(@RequestBody Book book) {
        Map<String, Object> response = new HashMap<>();
        int result = bookService.insert(book);
        if (result > 0) {
            response.put("success", true);
            response.put("message", "书籍添加成功");
            return ResponseEntity.ok(response);
        } else {
            response.put("success", false);
            response.put("message", "书籍添加失败");
            return ResponseEntity.badRequest().body(response);
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<Map<String, Object>> updateBook(@PathVariable Long id, @RequestBody Book book) {
        Map<String, Object> response = new HashMap<>();
        book.setId(id);
        int result = bookService.update(book);
        if (result > 0) {
            response.put("success", true);
            response.put("message", "书籍更新成功");
            return ResponseEntity.ok(response);
        } else {
            response.put("success", false);
            response.put("message", "书籍更新失败");
            return ResponseEntity.badRequest().body(response);
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, Object>> deleteBook(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        int result = bookService.deleteById(id);
        if (result > 0) {
            response.put("success", true);
            response.put("message", "书籍删除成功");
            return ResponseEntity.ok(response);
        } else {
            response.put("success", false);
            response.put("message", "书籍删除失败");
            return ResponseEntity.badRequest().body(response);
        }
    }
}