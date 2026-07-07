package com.example.library.service.impl;

import com.example.library.entity.AiLog;
import com.example.library.mapper.AiLogMapper;
import com.example.library.service.AiLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AiLogServiceImpl implements AiLogService {

    private final AiLogMapper aiLogMapper;

    @Autowired
    public AiLogServiceImpl(AiLogMapper aiLogMapper) {
        this.aiLogMapper = aiLogMapper;
    }

    @Override
    public void saveLog(AiLog log) {
        aiLogMapper.insert(log);
    }
}