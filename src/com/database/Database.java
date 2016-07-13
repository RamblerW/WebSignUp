package com.database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Database {

	private static final String driver="com.mysql.jdbc.Driver";
	private static final String url="jdbc:mysql://139.129.39.115:3306/SignUp";
	private static final String username="bosswang";
	private static final String password="wxq123456";
	
	public Connection getCon(){
		Connection con=null;
		try {
			Class.forName(driver);
			//OracleDriver od=new OracleDriver();
			con=DriverManager.getConnection(url,username,password);
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			System.out.println("数据库连接找不到类异常");
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			System.out.println("数据库错误！");
			e.printStackTrace();
		}
		return con;
	}
}
