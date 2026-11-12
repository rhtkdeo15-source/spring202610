package com.example.demo.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Chart;

@Mapper
public interface ChartMapper {
	List<Chart> selectChartList();
	
}
