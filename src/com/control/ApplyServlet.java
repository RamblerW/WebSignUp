package com.control;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.bean.ApplyBean;
import com.database.ApplyDatabase;
import com.jspsmart.upload.SmartUpload;
import com.jspsmart.upload.SmartUploadException;

public class ApplyServlet extends HttpServlet {

	static Logger log=Logger.getLogger(TestSnoServlet.class);
	/**
	 * Constructor of the object.
	 */
	public ApplyServlet() {
		super();
	}

	/**
	 * Destruction of the servlet. <br>
	 */
	public void destroy() {
		super.destroy(); // Just puts "destroy" string in log
		// Put your code here
	}

	/**
	 * The doGet method of the servlet. <br>
	 *
	 * This method is called when a form has its tag value method equals to get.
	 * 
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		this.doPost(request, response);
	}

	/**
	 * The doPost method of the servlet. <br>
	 *
	 * This method is called when a form has its tag value method equals to post.
	 * 
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		PrintWriter out = response.getWriter();
		int flag=-1;//标志位
		//1、实例化smartupload对象
		SmartUpload su=new SmartUpload();
		//2、初始化信息并调用upload()的方法
		su.initialize(this.getServletConfig(), request,response);
		try {
			su.upload();
			//3、上传文件参数设置
			su.setAllowedFilesList("jpg,png,bmp,jpeg");//设置上传文件格式
			su.setMaxFileSize(5*1024*1024);//设置上传文件大小单位是字节（B）
			//4、将上传的文件保存到指定目录：调用save()或saveAs()方法
			String sno=su.getRequest().getParameter("sno");
			String type=su.getFiles().getFile(0).getFileExt();//获取文件格式
			String photo = sno+"."+type;//以学号命名图片
			su.getFiles().getFile(0).saveAs("/upload/"+photo);//保存在容器目录下
		} catch (SmartUploadException e) {
			// TODO Auto-generated catch block
			log.error("SmartUploadException——ApplyServlet.java");
			e.printStackTrace();
		}
		ApplyDatabase ad=new ApplyDatabase();
		ApplyBean applyBean=setBean(su,request,response);
		//将数据插入数据库
		flag=ad.toInsert(applyBean);
		//获取浏览器的编码格式
		if(flag>0){
			out.print("<script>alert('Success !');window.location.href='http://www.xautkx.com';</script>");
		}else{
			out.print("<script>alert('Fail !');window.history.go(-1);</script>");
		}
		out.flush();
		out.close();
	}
	public ApplyBean setBean(SmartUpload su,HttpServletRequest request, HttpServletResponse response){
		ApplyBean applyBean=new ApplyBean();
		String name=su.getRequest().getParameter("name");
		String sno=su.getRequest().getParameter("sno");
		String college=su.getRequest().getParameter("college");
		String className=su.getRequest().getParameter("className");
		String pnum=su.getRequest().getParameter("pnum");
//		String email=su.getRequest().getParameter("email");
		String depart1=su.getRequest().getParameter("depart1");
		String depart2=su.getRequest().getParameter("depart2");
		String[] time=su.getRequest().getParameterValues("time");
		String time1="";
		String time2="";
		String time3="";
		if(time.length==3){
			time1="√";
			time2="√";
			time3="√";
		}else if(time.length==2){
			if(time[0].equals("time1")&&time[1].equals("time2")){
				time1="√";
				time2="√";
			}
			if(time[0].equals("time1")&&time[1].equals("time3")){
				time1="√";
				time3="√";
			}
			if(time[0].equals("time2")){
				time2="√";
				time3="√";
			}
		}else{
			if(time[0].equals("time1")){
				time1="√";
			}else if(time[0].equals("time2")){
				time2="√";
			}else{
				time3="√";
			}
		}
		//获得图片路径
		String photo = "/upload/"+sno+"."+su.getFiles().getFile(0).getFileExt();//以学号命名图片
//		String photo = "/upload/"+sno+su.getFiles().getFile(0).getFileName();
		String ques1=su.getRequest().getParameter("ques1");
		String ques2=su.getRequest().getParameter("ques2");
		String ques3=su.getRequest().getParameter("ques3");
		String sex=su.getRequest().getParameter("sex");
		String room=su.getRequest().getParameter("room");
		String exper=su.getRequest().getParameter("exper");
		String reward=su.getRequest().getParameter("reward");
		
		applyBean.setName(name);
		applyBean.setSno(sno);
		applyBean.setCollege(college);
		applyBean.setClassName(className);
		applyBean.setPnum(pnum);
		applyBean.setDepart1(depart1);
		applyBean.setDepart2(depart2);
		applyBean.setPhoto(photo);
		applyBean.setQues1(ques1);
		applyBean.setQues2(ques2);
		applyBean.setQues3(ques3);
		applyBean.setTime1(time1);
		applyBean.setTime2(time2);
		applyBean.setTime3(time3);
		applyBean.setSex(sex);
		applyBean.setRoom(room);
		applyBean.setExper(exper);
		applyBean.setReward(reward);
		return applyBean;
	}
	/**
	 * Initialization of the servlet. <br>
	 *
	 * @throws ServletException if an error occurs
	 */
	public void init() throws ServletException {
		// Put your code here
		
	}
}
