package com.example.demo.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.ChartMapper;
import com.example.demo.model.Chart;

@Service
public class ChartService {
	@Autowired
	ChartMapper chartMapper;
	
	public HashMap<String, Object> getChartList() {
		HashMap<String, Object> resultMap = new HashMap();
		List<Chart> list = chartMapper.selectChartList();
		
		resultMap.put("list", list);
		resultMap.put("result", "success");
		return resultMap;
	}

}