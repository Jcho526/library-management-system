package com.example.library.mapper;

import com.example.library.entity.AiLog;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AiLogMapper {
    int insert(AiLog log);
}