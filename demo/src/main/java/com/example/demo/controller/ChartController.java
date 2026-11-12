package com.example.demo.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dao.ChartService;
import com.google.gson.Gson;

@Controller
public class ChartController {
	@Autowired
	ChartService chartService;
	
	@RequestMapping("/chart1.do")
	public String test(Model model) throws Exception{
		
		return "/chart/chart1";
	}
	
	@RequestMapping("/chart2.do")
	public String chart2(Model model) throws Exception{
		
		return "/chart/chart2";
	}
	
	@RequestMapping("/chart3.do")
	public String chart3(Model model) throws Exception{
		
		return "/chart/chart3";
	}
	
	@RequestMapping(value = "/chart3.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String chart3(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = chartService.getChartList();
		
		return new Gson().toJson(resultMap); 
	}
}
