package com.example.demo.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Product;

@Mapper
public interface ProductMapper {
	List<Product> selectProductList(HashMap<String, Object> map);
	
	Product selectProduct(HashMap<String, Object> map);
	
	List<Product> selectCategoryList(HashMap<String, Object> map);
	
	int updateProduct(HashMap<String, Object> map);
}
