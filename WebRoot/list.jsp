<%@ page language="java" isELIgnored="false" import="java.util.*,com.database.*,org.json.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<%
	String username=(String)session.getAttribute("SignUpUser");
	String password=(String)session.getAttribute("SignUpPassword");
	if(username==null||!username.equals("root")||password==null||!password.equals("admin")){
		//页面跳转
		out.print("<script>alert('请先登录！');window.location.href='login.jsp';</script>");
	}
%>
<!DOCTYPE html>
<html lang="en">
<head>
	<base href="<%=basePath%>">
	
	<meta charset="UTF-8">
	<!-- 移动端视图 禁止屏幕缩放 -->
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<title>列表页</title>
	<link rel="shortcut icon" href="<%=basePath %>img/logo.png" type="image/x-icon" />
	<link rel="stylesheet" href="<%=basePath %>css/bootstrap.min.css">
	<style>
		*{
			margin: 0;
			padding: 0;
			font-family: "MicrosoftYaHei";
		}
		#wrap{
			margin-top: 50px;
		}
		table th,td{
			text-align: center;
			font-size: 20px;
		}
		#search{
			margin-bottom: 20px;
		}
		#searchTip{
			color: red;
			font-weight: bold;
			display: none;
		}
	</style>
</head>
<body>
	
	<div id="wrap" class="col-md-10 col-md-offset-1">
		
			<div class="form-group col-md-2">
				<input type="text" class="form-control" id="searchInput" placeholder="请输入学号...">
			</div>
			<button type="button" class="btn btn-primary" id="searchBtn">搜索</button>
			<span id="searchTip">该学号信息不存在</span>
		

		<table class="table table-bordered table-hover " id="listTab">
			<tr class="active">
				<th class="col-md-1">序号</th>
				<th class="col-md-2">姓名</th>
				<th class="col-md-2">学号</th>
				<th class="col-md-2">手机号</th>
				<th class="col-md-2">操作</th>
			</tr>
		</table>
		<button type="button" class="btn btn-danger" id="clearStorage"> 清空缓存 </button>
	</div>
	
	<script src="<%=basePath %>js/jquery.min.js"></script>
	<script src="<%=basePath %>js/bootstrap.min.js"></script>
	<script>
		$(function(){
			$(document).ready(function(){
				//Ajax查询信息
				$.ajax({
					url:"<%=basePath%>servlet/ListServlet",
					type:'post',
					data:{
						sno: "json",
						time:new Date().getTime(),
						cache:false
					},
					success:function(resultJson){
// 						alert(resultJson); 
// 						console.log(resultJson);
						var result = ajaxParse(resultJson);
						run(result);
					},
					error:function(result){
						alert("出错！");
					}
				});
				
			});
		});	

		//根据服务器端数据创建信息列表
		function createTab(obj){
			var num;
			for(key in obj){
				num = $("tr").size();
				$("#listTab").append("<tr id="+obj[key]["sno"]+"><td>"+num+"</td><td>"+obj[key]["name"]+"</td><td>"+obj[key]["sno"]+"</td><td>"+obj[key]["pnum"]+"</td><td><button type='button' class='btn btn-info'>详细</button></td></tr>");
			}
		}
		//localStorage save操作
		function save(key,obj){
			var storage = window.localStorage,
				str = JSON.stringify(obj);	//localStorage只能传递字符串 对象转字符串

			//将服务器端获得的信息保存在本地
			storage.setItem(key,str);
		}

		//根据doneList初始化已面试行的样式
		function initClass(list){
			for(var doneID in list){
				$("#"+list[doneID]).addClass("info");
			}
		}
		
		//ajax数据解析为对象
		function ajaxParse(resultJson){
			var listJSON = $.parseJSON(resultJson),
				infoObj = {};
			for(var key in listJSON.json){
				var personObj = listJSON.json[key],
					person = {
						name:personObj.name,
						sex:personObj.sex,
						className:personObj.className,
						sno:personObj.sno,
						room:personObj.room,
						college:personObj.college,
						pnum:personObj.pnum,
						photo:personObj.photo,
						exper:personObj.exper,
						reward:personObj.reward,
						depart1:personObj.depart1,
						depart2:personObj.depart2,
						ques1:personObj.ques1,
						ques2:personObj.ques2,
						ques3:personObj.ques3,
					};
				infoObj[person.sno] = person;
			}
			console.log(infoObj);
			return infoObj;
		}
		function run(info){
			var doneList = window.localStorage.getItem("doneList") ? window.localStorage.getItem("doneList").split(',') : [];
				
			//根据信息创建表格
			createTab(info);

			//初始化行样式(已面试则该行变成蓝色)
			initClass(doneList);
			
			//将该对象学号保存到localStorage传递给详情页
			$(".btn-info").click(function(eve){
				var ID = eve.target.parentNode.previousSibling.previousSibling.innerHTML;
				//将要打开的同学信息保存至本地
				save('tempPass',info[ID]);

				window.open('detail.html');
			});


			//定时器定时检测localStorage变化
			var timer = setInterval(function(){
				var storage = window.localStorage,
					doneID = storage.getItem("donePass"),
					clearID = storage.getItem("clearPass");
				doneList = window.localStorage.getItem("doneList") ? window.localStorage.getItem("doneList").split(',') : [];
				//有donePass缓存了
				if(doneID){
					//完成数组中未包含该学号，则加入数组并修改样式
					if(($.inArray(doneID,doneList)==-1)){
						doneList.push(doneID);
						if(!$("#"+doneID).hasClass("info")){
							$("#"+doneID).addClass("info");
							console.log("add");
						}
					}
					
					//更新已面试的列表
					storage.setItem("doneList",doneList);
					//删除donePass缓存
					storage.removeItem("donePass");
				}

				//有clearPass缓存了
				if(clearID){
					console.log("clear");
					if($("#"+clearID).hasClass("info")){
						$("#"+clearID).removeClass("info");
					}
					//删除clearPass缓存
					storage.removeItem("clearPass");
				}
			},500);
			
			//清空缓存按键
			$("#clearStorage").click(function(){
				var r=confirm("是否要删除所有数据？");
				var storage = window.localStorage;
				for(var key in storage){
					storage.removeItem(key);
				}
			});

			//搜索按键
			$("#searchBtn").click(function(){
				var ID = $("#searchInput").val();
				console.log(info[ID]);
				if(info[ID]){
					$("#searchTip").hide();
					//将要打开的同学信息保存至本地
					save('tempPass',info[ID]);
					//打开详情页
					window.open('detail.html');
				}else{
					$("#searchTip").show();
				}
			});
			//回车执行搜索
			$('#searchInput').keyup(function () {
	            if (event.keyCode == "13") {
	      			var ID = $("#searchInput").val();
					console.log(info[ID]);
					if(info[ID]){
						$("#searchTip").hide();
						//将要打开的同学信息保存至本地
						save('tempPass',info[ID]);
						//打开详情页
						window.open('detail.html');
					}else{
						$("#searchTip").show();
					}
	            }
	        });
		}
	</script>
</body>
</html>
