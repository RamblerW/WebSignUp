<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML>
<html>
  <head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">
    <!-- 移动端视图 禁止屏幕缩放 -->
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	
    <title>纳新报名表</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,Chrome=1" />
    <meta name="renderer" content="Webkit">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<link rel="shortcut icon" href="<%=basePath%>img/logo.png" type="image/x-icon" />
	<link rel="stylesheet" type="text/css" href="<%=basePath%>css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="<%=basePath%>css/index.css">
  	<script src="<%=basePath%>js/jquery.min.js"></script>
  	<script src="<%=basePath%>js/jquery.placeholder.js"></script>
	<script src="<%=basePath%>js/bootstrap.min.js"></script>
	<script>
		$(function(){
			alert('友情提示：\n请勿在微信中打开该网页进行报名！\n建议使用IE9及以上版本或Chrome浏览器！');
			// Invoke the plugin
        	$('input, textarea').placeholder();
			$(document).ready(function(){
				//标志位
				var studentIDtrue=0;
				var inputPhonetrue=0;
				//设置提交按钮为不可用
				$("#submit").attr("disabled","disabled");
				//查看部门信息按钮点击事件
				$("#infoBtn").click(function(){
					$("#departmentInfo").fadeIn();	//部门信息框显示
					$("#mask").fadeIn();				//遮罩层显示
					$("body").css("overflow-y","hidden");	//	禁止页面滚动
				});
				//部门信息框关闭按钮点击事件
				$("#closeBtn").click(function(){
					$("#departmentInfo").fadeOut();	//部门信息框隐藏
					$("#mask").fadeOut();				//遮罩层隐藏
					$("body").css("overflow-y","scroll");	//恢复页面滚动
				});
				/*验证学号*/
				$("#sno").blur(function(){
					var sno=$("#sno").val();
					/*正则表达式匹配——验证10位的数字*/
					var reg = /^\d{10}$/;
					if(!reg.test(sno)){
						studentIDtrue=0;
						$("#snoerror").css("display","inline");
						$("#snoexist").css("display","none");
						$("#submit").attr("disabled","disabled");
					}else{
						studentIDtrue=1;
						$("#snoerror").css("display","none");
						$("#snoexist").css("display","none");
						if(inputPhonetrue==1){
							$("#submit").removeAttr("disabled");
						}
						//Ajax验证学号
						$.ajax({
							url:"<%=basePath%>servlet/TestSnoServlet",
							type:'post',
							data:{
								sno: $("#sno").val(),
								time:new Date().getTime(),
								cache:false
							},
							success:function(result){
 								var resultJson=eval("("+result+")");
 								//如果学号存在，则给出提示，并禁止提交
 								if(resultJson.snoNum>0){
 									$("#snoerror").css("display","none");
 									$("#snoexist").css("display","inline");
 									$("#submit").attr("disabled","disabled");
 								}
							},
							error:function(result){
								alert("请求错误！");
							}
						});
					}
				});
				/*验证手机号格式*/
				$("#pnum").blur(function(){
					var pnum=$("#pnum").val();
					/*正则表达式匹配——验证11位的数字*/
					var reg = /^\d{11}$/;
					if(!reg.test(pnum)){
						inputPhonetrue=0;
						$("#pnumerror").css("display","inline");
						$("#submit").attr("disabled","disabled");
					}else{
						inputPhonetrue=1;
						$("#pnumerror").css("display","none");
						if(studentIDtrue==1){
							$("#submit").removeAttr("disabled");
						}
					}
				});
				/*验证数据是否有空白*/
				$("#mainform").submit(function(){
					/*获取照片格式*/
					var filepath=$("#photo").val();
					var extStart=filepath.lastIndexOf(".");
			        var ext=filepath.substring(extStart,filepath.length).toUpperCase();
			        var file=$("#photo");
			        //判断是否上传照片
			        if($.trim(file.val())==''){
			        	alert("请上传照片！");
			        }else
			        if(ext!=".BMP"&&ext!=".PNG"&&ext!=".JPG"&&ext!=".JPEG"){
			        	alert("照片限于bmp, png, jpeg, jpg格式！");
			        }else
			        if((file[0].files[0].size)>5*1024*1024){
			        	alert("照片过大！");
			        }else
			        /*判断数据是否为空*/
					if(($("#name").val()=="")||($("#sno").val()=="")||
						($("#college").val()=="")||($("#className").val()=="")||($("#pnum").val()=="")||
						($("#depart1").val()=="")||($("#depart2").val()=="")||(($("#boy").is(":checked")==false)&&($("#girl").is(":checked")==false))||
						($("#room").val()=="")||($("#exper").val()=="")||($("#reward").val()=="")||
						($("#ques1").val()=="")||($("#ques2").val()=="")||($("#ques3").val()=="")||
						(($("#time1").is(":checked")==false)&&($("#time2").is(":checked")==false)&&($("#time3").is(":checked")==false))
					  ){
						
						alert("请填写所有信息！");
						
					}else{
						$("#submit").attr("disabled","disabled");/*防重复提交*/
						$("#mainform").unbind('submit');
						$("#mainform").submit();
						return true;
					}
					return false;
				});
			});
			/*window.onload = function(){ 
			　　alert("请注意：每一项都请认真填写！");
			}; */
		});
	</script>
  </head>
  <body>
    <div class="person col-md-6 col-md-offset-3 col-xs-10 col-xs-offset-1">
    	<form id="mainform" class="form-horizontal" action="<%=basePath%>servlet/ApplyServlet" method="post" enctype="multipart/form-data">
			<!-- 标题 -->
			<h1 class="tableTitle center-block">自动化学院学生科协纳新报名表</h1>
			<p class="mustMark" style="text-align: center;">* 1.请勿在微信中报名！建议使用IE9及以上版本或Chrome浏览器！</p>
			<p class="mustMark" style="text-align: center;">* 2.线上报名后还需要提交纸质版申请表，申请表可以去主干道领取！</p>
			<!-- 姓名 -->
			<div class="form-group">
		    	<label for="inputName" class="col-md-2 control-label "><i class="mustMark">* </i>姓名</label>
		    	<div class="col-md-8">
		      		<input type="text" class="form-control" name="name" id="name" placeholder="Name">
		    	</div>
		  	</div>
		  	<!-- 性别 -->
			<div class="form-group">
		    	<label for="inputSex" class="col-md-2 control-label "><i class="mustMark">* </i>性别</label>
		    	<div class="col-md-2">
		      		<input type="radio" name="sex" id="boy" value="男">&nbsp;&nbsp;男
		      	</div>
		      	<div class="col-md-2">
		      		<input type="radio" name="sex" id="girl" value="女">&nbsp;&nbsp;女
		    	</div>
		    </div>
		  	<!-- 宿舍 -->
		  	<div class="form-group">
		    	<label for="inputHouse" class="col-md-2 control-label "><i class="mustMark">* </i>宿舍</label>
		    	<div class="col-md-8">
		      		<input type="text" class="form-control" name="room" id="room" placeholder="Room">
		    	</div>
		  	</div>
		  	<!-- 学号 -->
		  	<div class="form-group">
		    	<label for="studentID" class="col-md-2 control-label"><i class="mustMark">* </i>学号</label>
		    	<div class="col-md-8">
		      		<input type="text" class="form-control" name="sno" id="sno" placeholder="Student ID">
		    	</div>
		      	<span id="snoerror" class="mustMark" style="display: none;">学号有误</span>
		      	<span id="snoexist" class="mustMark" style="display: none;">该学号已报名！</span>
		  	</div>
		  	<!-- 学院 -->
		  	<div class="form-group">
		    	<label for="inputCollege" class="col-md-2 control-label"><i class="mustMark">* </i>学院</label>
		    	<div class="col-md-8">
		      		<select class="form-control" name="college" id="college">
		      			<option></option>
					  	<option>自动化学院</option>
					  	<option>计算机学院</option>
					  	<option>机仪学院</option>
					  	<option>水电学院</option>
					  	<option>材料学院</option>
					  	<option>印包学院</option>
					  	<option>经管学院</option>
					  	<option>理学院</option>
					  	<option>人文学院</option>
					  	<option>土木学院</option>
					  	<option>艺设学院</option>
					</select>
		    	</div>
		  	</div>
		  	<!-- 班级 -->
		  	<div class="form-group">
		    	<label for="inputClazz" class="col-md-2 control-label"><i class="mustMark">* </i>班级</label>
		    	<div class="col-md-8">
		      		<input type="text" class="form-control" name="className" id="className" placeholder="Class">
		    	</div>
		  	</div>
			<!-- 手机号 -->
		  	<div class="form-group">
		    	<label for="inputPhone" class="col-md-2 control-label"><i class="mustMark">* </i>手机号码</label>
		    	<div class="col-md-8">
		      		<input type="text" class="form-control" name="pnum" id="pnum" placeholder="Phone Num">
		    	</div>
		    	<span id="pnumerror" class="mustMark" style="display: none;">手机号码有误</span>
		  	</div>
		  	<!-- 邮箱 -->
<!-- 		  	<div class="form-group"> -->
<!-- 		    	<label for="inputEmail" class="col-md-2 control-label"><i class="mustMark">* </i>Email</label> -->
<!-- 		    	<div class="col-md-8"> -->
<!-- 		      		<input type="email" class="form-control" name="email" id="inputEmail" placeholder="Email"> -->
<!-- 		    	</div> -->
<!-- 		  	</div> -->
		  	<!-- 部门 -->
		  	<div class="form-group" id="department">
		    	<label class="col-md-2 control-label"><i class="mustMark">* </i>期望的部门（双选）</label>
		    	<div class="col-md-4">
		      		<select class="form-control" style="margin-bottom: 10px" name="depart1" id="depart1">
					  	<option></option>
						<option>秘书部</option>
					  	<option>实验管理部</option>
					  	<option>竞赛组织部</option>
					  	<option>对外交流部</option>
					  	<option>宣传策划部</option>
					</select>
		    	</div>
		    	<div class="col-md-4">
		      		<select class="form-control" style="margin-bottom: 10px" name="depart2" id="depart2">
					  	<option></option>
						<option>秘书部</option>
					  	<option>实验管理部</option>
					  	<option>竞赛组织部</option>
					  	<option>对外交流部</option>
					  	<option>宣传策划部</option>
					</select>
		    	</div>
		    	<button type="button" class="btn btn-info" id="infoBtn">部门详细信息</button>
		  	</div>
		  	<!-- 面试时间 -->
		  	<div class="form-group" id="interview">
		  		<label class="col-md-2 control-label"><i class="mustMark">* </i>可面试时间</label>
		  		<div class="col-md-8">
		  			<input type="checkbox" name="time" id="time1" value="time1"/>6月11日19:00-22:00
		  			<input type="checkbox" name="time" id="time2" value="time2" style="margin-left: 10%"/>6月12日19:00-22:00
		  			<input type="checkbox" name="time" id="time3" value="time3" style="margin-left: 10%"/>其他
		  		</div>
		  	</div>
		  	<!-- 照片上传 -->
		  	<div class="form-group">
			    <label for="photo" class="col-md-2 control-label "><i class="mustMark">* </i>照片上传</label>
			    <div class="col-md-4">
		      		<input type="file" id="photo" name="photo" style="width: 100%">
		    	</div>
			    	<span style="color:red;">支持JPG、PNG、BMP格式，大小不超5M</span>
			</div>
			<!-- 科技制作经验 -->
		  	<div class="form-group">
		  		<label for="exper" class="quesLabel control-label"><i class="mustMark">* </i>科技制作经验</label>
		  		<br />
		  		<textarea rows="5" id="exper" name="exper" class="col-md-10 col-md-offset-1 col-xs-10 col-xs-offset-1"></textarea>
		  	</div>
			<!-- 获奖情况 -->
		  	<div class="form-group">
		  		<label for="reward" class="quesLabel control-label"><i class="mustMark">* </i>大学以来各方面获奖情况</label>
		  		<br />
		  		<textarea rows="5" id="reward" name="reward" class="col-md-10 col-md-offset-1 col-xs-10 col-xs-offset-1"></textarea>
		  	</div>
			<!-- 问题1 -->
		  	<div class="form-group">
		  		<label for="ques1" class="quesLabel control-label"><i class="mustMark">* </i>个人简介（你可以从学习成绩、性格特点、爱好、特长等多方面进行简述）</label>
		  		<br />
		  		<textarea rows="5" id="ques1" name="ques1" class="col-md-10 col-md-offset-1 col-xs-10 col-xs-offset-1"></textarea>
		  	</div>
			<!-- 问题2 -->
		  	<div class="form-group">
		  		<label for="ques2" class="quesLabel control-label"><i class="mustMark">* </i>你为什么选择科协？如果你是科协成员，你会做些什么？</label>
		  		<br />
		  		<textarea rows="5" id="ques2" name="ques2" class="col-md-10 col-md-offset-1 col-xs-10 col-xs-offset-1"></textarea>
		  	</div>
		  	<!-- 问题3 -->
		  	<div class="form-group">
		  		<label for="ques3" class="quesLabel control-label"><i class="mustMark">* </i>有没有加入其他社团？有什么收获与体会？</label>
		  		<br />
		  		<textarea rows="5" id="ques3" name="ques3" class="col-md-10 col-md-offset-1 col-xs-10 col-xs-offset-1"></textarea>
		  	</div>
		  	<!-- 联系我们 -->
		  	<div class="form-group">
	  			<label for="call" class="quesLabel control-label">联系我们</label>
	  			<br />
  				<table class="control-label" style="color: #337AB7;font-weight: bold;margin-left: 12%">
  					<tr>
  						<td style="text-align: right;">Tel&nbsp;:&nbsp;</td>
  						<td style="text-align: left;">18829027594</td>
  					</tr>
  					<tr>
  						<td style="text-align: right;">E-mail&nbsp;:&nbsp;</td>
  						<td style="text-align: left;">ke_xaut@163.com</td>
  					</tr>
  					<tr>
  						<td style="text-align: right;">Add&nbsp;:&nbsp;</td>
  						<td style="text-align: left;">教五楼地-12科协办公室</td>
  					</tr>
  				</table>
		  	</div>
			<button type="submit" class="btn btn-primary center-block" id="submit">确认提交</button>
		</form>
	</div>
    <div class="departmentInfo col-md-6 col-md-offset-3 col-sm-8 col-sm-offset-2" id="departmentInfo">
		<h2>科协各部门简介</h2>
			<h3>秘书部：</h3>
		<p>
			1．	起草活动策划案，负责活动签到及总结；<br>
			2．	负责科协成员的各项考核；<br>
			3．	负责科协各类文件的收集、分类和存档；<br>
			4．	负责科协实验室及各项活动的值班安排。<br>
		</p>
			<h3>实验管理部：</h3>
		<p>
			1．	负责科协的物资采购、调用及管理；<br>
			2．	管理科协各实验室的所有元件、工具和设备；<br>
			3．	负责实验室规章制度的制定与实施；<br>
			4．	负责所有作品相关文档的管理。<br>
		</p>
			<h3>宣传策划部：</h3>
		<p>
			1．	负责活动的海报、视频、展架、展板等宣传用品的设计与制作，负责科协场地的布置；<br>
			2．	负责活动照片的拍摄及活动新闻稿的撰写；<br>
			3．	开发、管理、运营科协官方网站；<br>
			4．	负责科协报纸、期刊的创作与发行。<br>
		</p>
			<h3>竞赛组织部: </h3>
		<p>
			1．	负责我院“新星杯”、“理奥杯”及校科技节等科技竞赛的相关操作事物，包括作品收集、管理及组织作品评审；<br>
			2．	积极联系、组织我院学生参加国家、省市大型竞赛活动；<br>
			3．	负责教授讲坛、青年教师讲座、科协公开课及各类比赛培训工作的相关事宜；<br>
			4．	联系和审批活动场地、活动用品，并负责处理各类突发情况。<br>
		</p>
			<h3>对外交流部：</h3>
		<p>
			1．	负责我院与校内其他科技社团、学术机构的沟通与合作；<br>
			2．	负责科协与校外研究性学术机构及商业性机构的技术交流；<br>
			3．	负责科协微信平台的运营；<br>
			4．	负责科协对外形象的推广、优化工作。<br>
		</p>
			<h3 style="color:red">注意</h3>
		<p>
			请选择两个感兴趣的部门，该选择并非最终结果。<br>
			分各部门只是方便管理与细化分工，不影响培训、比赛等其他事务。<br>
		</p>
		<button type="button" class="btn btn-danger center-block" id="closeBtn">关闭</button>
	</div>
	<div id="mask"></div>
	
  </body>
</html>
