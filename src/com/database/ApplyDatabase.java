package com.database;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.bean.ApplyBean;

public class ApplyDatabase extends Database{

	Connection con=null;
	PreparedStatement ps=null;
	Statement st=null;
	ResultSet rs=null;
	//添加数据
	public int toInsert(ApplyBean apply){
		int i=0;
		//获得连接
		con=getCon();
		//编写sql语句
		String sql="insert into applyInfo values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		try {
			//预编译
			ps=con.prepareStatement(sql);
			//给占位符赋值
			ps.setString(1, apply.getName());
			ps.setString(2, apply.getSno());
			ps.setString(3, apply.getCollege());
			ps.setString(4, apply.getClassName());
			ps.setString(5, apply.getPnum());
			ps.setString(6, apply.getDepart1());
			ps.setString(7, apply.getDepart2());
			ps.setString(8, apply.getPhoto());
			ps.setString(9, apply.getQues1());
			ps.setString(10, apply.getQues2());
			ps.setString(11, apply.getQues3());
			ps.setString(12, apply.getTime1());
			ps.setString(13, apply.getTime2());
			ps.setString(14, apply.getSex());
			ps.setString(15, apply.getRoom());
			ps.setString(16, apply.getExper());
			ps.setString(17, apply.getReward());
			ps.setString(18, apply.getTime3());
			//执行数据库操作
			i=ps.executeUpdate();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			//关闭连接
			toClose(rs, ps, con, st);
		}
		return i;//返回添加的数据数量
	}
	//查询数据
	public String toSelect(){
		JSONArray jsonArray = new JSONArray();
		//获得连接
		con=getCon();
		//编写sql语句
		String sql="select * from applyInfo";
			try {
				//预编译
				ps=con.prepareStatement(sql);
				//执行数据库操作
				rs=ps.executeQuery();
				while(rs.next()){
					
					JSONObject member=new JSONObject();
					
					member.put("sno",rs.getString("sno"));
					member.put("name",rs.getString("name"));
					member.put("college",rs.getString("college"));
					member.put("className",rs.getString("className"));
					member.put("pnum",rs.getString("pnum"));
					member.put("depart1",rs.getString("depart1"));
					member.put("depart2",rs.getString("depart2"));
					member.put("photo",rs.getString("photo"));
					member.put("ques1",rs.getString("ques1"));
					member.put("ques2",rs.getString("ques2"));
					member.put("ques3",rs.getString("ques3"));
					member.put("time1",rs.getString("time1"));
					member.put("time2",rs.getString("time2"));
					member.put("sex",rs.getString("sex"));
					member.put("room",rs.getString("room"));
					member.put("exper",rs.getString("exper"));
					member.put("reward",rs.getString("reward"));
					member.put("time3",rs.getString("time3"));
					
					jsonArray.put(member);
				}
//				jsonMember.put("list", jsonArray);
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			} finally{
				//关闭连接
				toClose(rs, ps, con, st);
		}
		return jsonArray.toString();//返回添加的数据数量
	}
//	//查询数据
//	public List<ApplyBean> toSelect(){
//		ApplyBean applybean;
//		List<ApplyBean> list=new ArrayList<ApplyBean>();
//		//获得连接
//		con=getCon();
//		//编写sql语句
//		String sql="select * from applyInfo";
//		try {
//			//预编译
//			ps=con.prepareStatement(sql);
//			//执行数据库操作
//			rs=ps.executeQuery();
//			while(rs.next()){
//				applybean=new ApplyBean();
//				
//				applybean.setName(rs.getString("name"));
//				applybean.setSno(rs.getString("sno"));
//				applybean.setCollege(rs.getString("college"));
//				applybean.setClassName(rs.getString("className"));
//				applybean.setPnum(rs.getString("pnum"));
//				applybean.setDepart1(rs.getString("depart1"));
//				applybean.setDepart2(rs.getString("depart2"));
//				applybean.setPhoto(rs.getString("photo"));
//				applybean.setQues1(rs.getString("ques1"));
//				applybean.setQues2(rs.getString("ques2"));
//				applybean.setQues3(rs.getString("ques3"));
//				applybean.setTime1(rs.getString("time1"));
//				applybean.setTime2(rs.getString("time2"));
//				applybean.setSex(rs.getString("sex"));
//				applybean.setRoom(rs.getString("room"));
//				applybean.setExper(rs.getString("exper"));
//				applybean.setReward(rs.getString("reward"));
//				applybean.setTime3(rs.getString("time3"));
//				
//				list.add(applybean);
//			}
//		} catch (SQLException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}finally{
//			//关闭连接
//			toClose(rs, ps, con, st);
//		}
//		return list;//返回添加的数据数量
//	}
	//验证主键是否存在
	public int toCheckSno(String sno){
		int i=0;
		//获得连接
		con=getCon();
		//编写sql语句
		String sql="select * from applyInfo where sno=?";
		try {
			//预编译
			ps=con.prepareStatement(sql);
			//给占位符赋值
			ps.setString(1, sno);
			//执行数据库操作
			rs=ps.executeQuery();
			if(rs.next()){
				i++;
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			//关闭连接
			toClose(rs, ps, con, st);
		}
		return i;//返回添加的数据数量
	}
	//导出数据到本地——excel
	public int toExport(){
		int i=0;
		//获得连接
		con=getCon();
		//编写sql语句
		String sql="select * into outfile '/applyInfo.xls'";
		try {
			//预编译
			ps=con.prepareStatement(sql);
			//执行数据库操作
			i=ps.executeUpdate();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			//关闭连接
			toClose(rs, ps, con, st);
		}
		return i;//返回添加的数据数量
	}
	//关闭连接
	public void toClose(ResultSet rs,PreparedStatement ps,Connection con,Statement st) {
		try {
			if(rs!=null){
				rs.close();
			}
			if(ps!=null){
				ps.close();
			}
			if(st!=null){
				st.close();
			}
			if(con!=null){
				con.close();
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	public static void main(String[] args) {
		ApplyDatabase ad=new ApplyDatabase();
		ad.toExport();
	}
}

