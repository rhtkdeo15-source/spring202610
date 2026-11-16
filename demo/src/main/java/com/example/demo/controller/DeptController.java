package com.example.demo.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dao.DeptService;
import com.google.gson.Gson;

@Controller
public class DeptController {
	@Autowired
	DeptService deptService;
	
	@RequestMapping("/dept/list.do")
	public String test(Model model) throws Exception{
		
		return "/dept/list";
	}
	
	@RequestMapping(value = "/dept/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String login(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = deptService.getDeptList(map);
		
		return new Gson().toJson(resultMap); 
	}
	
	@RequestMapping("/dept/view.do")
	public String view(Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		model.addAttribute("deptno", map.get("deptno"));
		return "/dept/view";
	}
	
	@RequestMapping(value = "/dept/view.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String view1(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = deptService.getDept(map);
		
		return new Gson().toJson(resultMap); 
	}
	
	@RequestMapping("/dept/add.do")
	public String add(Model model) throws Exception{
		
		return "/dept/add";
	}
	
	@RequestMapping(value = "/dept/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String add(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = deptService.addDept(map);
		
		return new Gson().toJson(resultMap); 
	}
	
	@RequestMapping(value = "/dept/remove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String remove(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = deptService.removeDept(map);
		
		return new Gson().toJson(resultMap); 
	}
	
	@RequestMapping("/dept/edit.do")
	public String edit(Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		model.addAttribute("deptno", map.get("deptno"));
		
		return "/dept/edit";
	}
	
	@RequestMapping(value = "/dept/edit.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String edit1(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = deptService.editDept(map);
		
		return new Gson().toJson(resultMap); 
		
	}
	
}
