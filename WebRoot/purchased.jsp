<%@page import="java.text.DateFormat"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import = "java.sql.*" %>

<jsp:useBean id="conn" scope="page" class="javabean.conn"/>
<jsp:useBean id="inf" scope="session" class="javabean.inf"/>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<link href="css/css.css" rel="stylesheet" rev="stylesheet" type="text/css" />
	<title>拍拍网-已购买</title>
	<a name="head"></a>

</head>
<body>
	<div id="top">
	<a href="index.jsp"><img border="0"src="pic/mainlogo.png"></a>
	</div>

<form action="search.jsp" method="get">
   <% 
	 //inf内已经有了用户信息，直接显示登陆后首页
	 if(inf.getPhone()!=null)
	 {
	 %>
		<div id="bread">
			<pre>               <a href="index.jsp">首页</a>      <a href="cart.jsp">购物车</a>     <b><a href="purchased.jsp"><font color=#0080FF>已购买</font></a></b>      <a href="sale.jsp">我的商品</a>     <a href="userinf.jsp">我的资料</a>     <a href="logout.jsp">退出登录</a>  </pre>
		  </div>
		 <div id="search">
		 <input  name="search" placeholder="查询商品" value="" spellcheck="false" class="">
		 </div>
		 <div id="searchbutton">
		  <input type="image" border=0 src="pic/search.png"  onClick="this.form.submit()">
		 </div>
		  <div id="welcome">
		   <font color="gray">欢迎您，<%out.print(inf.getUsername()); %></font> 
		 </div>
	<% 
	}
	
	//r若是游客请先登录
	else 
	{
	%>  
					<script> alert("请先登录！")</script>
			
					<script language="javascript" type="text/javascript">
					window.location.href="login.jsp"
					</script>
					
		<%
	 
	}
		   
		  %>
   </form>

 <div id="navigation">
   <a href="search.jsp?search=衣服"><img border="0"src="pic/clothes.png"></a><br>
	<a href="search.jsp?search=食品"><img border="0"src="pic/food.png"></a><br> 
	<a href="search.jsp?search=图书"><img border="0"src="pic/book.png"></a><br>
	<a href="search.jsp?search=手机及配件"><img border="0"src="pic/cell.png"></a><br>
	<a href="search.jsp?search=电脑及配件"><img border="0"src="pic/computer.png"></a><br>
	<a href="search.jsp?search=家用电器"><img border="0"src="pic/electric.png"></a><br>
	<a href="search.jsp?search=其它"><img border="0"src="pic/others.png"></a><br>
	 <br><a><font size=2px;>作者：陈欣怡</font></a><br>
	 <a><font size=2px;>学号：1120112181</font></a><br>
	 <a><font size=2px;>班级：08111103</font></a><br>
	 <a><font size=2px;>电话：18810579183</font></a><br>
 </div>


<div id="main">
<%
	String goodid = request.getParameter("goodID"); 
	String[] select = (String[])request.getParameterValues("select[]");
	String[] choose = (String[])request.getParameterValues("choose[]");
	  
	 //若需删除	 
	 if(choose!=null){
	 	int numdel = choose.length;
	 	for(int i=0;i<numdel;i++){
				 		
				 String sql="delete from 12181_cart where 交易ID ='"+choose[i]+"';";
				  int rs = conn.executeUpdate(sql);
				
				    	
				}
	 }
	  	 
	 
	 //直接点击购买按钮
	
	 if(goodid!=null){
	 	//获取系统当前时间（精确到秒），用户手机号码+当前时间=交易ID
	 	java.text.SimpleDateFormat now = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	   	 java.util.Date current = new java.util.Date();
	   	 String date1= now.format(current);
	   	 String datetime=current.toString();
	   	 String[] temp = datetime.split(" ");
	   	 datetime = temp[5]+temp[1]+temp[2]+temp[3];
	   	
	   	 String saleid = inf.getPhone()+datetime;
	   	 
	   	 datetime = temp[5]+"-"+temp[1]+"-"+temp[2]+" "+temp[3];
	   	 
	 	String sql = "select * from 12181_sale where ID ='"+goodid+"';";
	 	ResultSet rs = conn.executeQuery(sql);
		rs.next();	
	   			 
	   	sql= "insert into 12181_cart values('"+saleid+"','"+goodid+"','"+rs.getString("名称")+"',"+rs.getInt("价格")+",'"+rs.getString("图片路径")+"',1,'"+inf.getPhone()+"','"+inf.getAddress()+"',1,'"+datetime+"','"+inf.getUsername()+"');";
	   	int x=conn.executeUpdate(sql);
	   	
	   	//更新商品表中的商品余量
	   	//若商品卖光，则删去该商品记录
	   	if(rs.getInt("余量")-1==0){
	   	sql = "delete from 12181_sale where ID='"+goodid+"';";
	   	 x=conn.executeUpdate(sql);  	
	   }
	   else{
	   	sql = "update 12181_sale set 余量=余量-1 where ID='"+goodid+"';";
	   	x=conn.executeUpdate(sql);
	   }
	   
	   //n/g9
	                                      out.print("<script>location.href='purchased.jsp';</script>");
	}
	//若是从购物车中购买
	else if(select!=null){
		
		int flag=0;//用于判断购物车中是否有商品预订数量>该商品余量 
		
		int num=select.length;
		
		for(int i=0;i<num;i++){
		
			java.text.SimpleDateFormat now = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		   	 java.util.Date current = new java.util.Date();
		   	 String date1= now.format(current);
		   	 String datetime=current.toString();
		   	 String[] temp = datetime.split(" ");
			 
			 datetime = temp[5]+"-"+temp[1]+"-"+temp[2]+" "+temp[3];
			 
			String sql = "select * from 12181_cart where 交易ID ='"+select[i]+"';";
			ResultSet cart = conn.executeQuery(sql);
			cart.next();
			
			
			sql = "select * from 12181_sale where ID ='"+cart.getString("商品ID")+"';";
			ResultSet sale = conn.executeQuery(sql);
			sale.next();
			
			int sum=sale.getInt("余量")-cart.getInt("数量");
			
			if(sum<0){ flag=1;continue;}
			else if(sum==0){
				 sql = "delete from 12181_sale where ID='"+cart.getString("商品ID")+"';";
				int rs = conn.executeUpdate(sql);
			}
			else{
				sql = "update 12181_sale set 余量="+sum+" where ID='"+cart.getString("商品ID")+"';";
				int rs = conn.executeUpdate(sql);
			}
			
			 	sql = "update 12181_cart set 购买=1 where 交易ID='"+select[i]+"';";
				int rs = conn.executeUpdate(sql);
				
				sql = "update 12181_cart set 时间='"+datetime+"' where 交易ID='"+select[i]+"';";
			    rs = conn.executeUpdate(sql);
			
		}
		
		if(flag==1)
				{
					out.print("<script> alert('"+"存在商品欲购买数量大于存货，该商品未购买成功。"+"')</script>"); 
					out.print("<script>location.href='cart.jsp';</script>");
				}
		else	out.print("<script>location.href='purchased.jsp';</script>");
	}
	
	 String sql = "select * from 12181_cart where 电话 ='"+inf.getPhone()+"' and 购买=1 order by 时间  desc;";
	 ResultSet rs=conn.executeQuery(sql);
	 rs.last();   
	 int num = rs.getRow();    
	 rs.first();
	 
	 if(num==0) out.print("暂无已购买商品。");
	 else{
	 	
	 	
	 	%>
	 	
	 	<div style="margin:30px 0px 0px 20px;width:600px; height:50px;border:solid 0px gray;" ><input type="image" border=0 src="pic/setall.png" onclick="checkAll()" >
		<input type="image" border=0 src="pic/unsetall.png" onclick="UNcheckAll()"></div>
		<form action="" method="post">
		<div style="margin:-50px 0px 0px 410px;width:400px; height:50px;border:solid 0px gray;" >
		<input type="image" border=0 src="pic/delete.png"  onclick="javascript:this.form.action='purchased.jsp';this.form.submit()">
		</div>
		<% 
	for(int i=0;i<num;i++)
	{		 
	%>
		<div style="margin:20px 0px 0px 50px;width:600px; height:240px;border:solid 1px gray;" >
			<div id="cartcheck" ><input type="checkbox" name="choose[]" value="<%out.print(rs.getString("交易ID"));%>"/> </div>
			<div id="cartpic"><a href="showgood.jsp?ID=<%out.print(rs.getString("商品ID"));%>"><img src="<%out.print(rs.getString("图片路径"));%>" /></a></div>
			<div id="cartshow" aligen="left" ><br>&nbsp;&nbsp;&nbsp;&nbsp;<B><%out.print(rs.getString("名称"));%> </B>
									  <br><br>&nbsp;&nbsp;&nbsp;&nbsp;数量：<%out.print(rs.getInt("数量"));%>
									  <br>&nbsp;&nbsp;&nbsp;&nbsp;总金额：￥<%out.print(rs.getInt("价格"));%>  x  <%out.print(rs.getString("数量"));%> = <%out.print(rs.getInt("价格")*rs.getInt("数量"));%> 元
									  <br>&nbsp;&nbsp;&nbsp;&nbsp;收货人：<%out.print(rs.getString("收货人"));%>
									  <br>&nbsp;&nbsp;&nbsp;&nbsp;收货地址：<%out.print(rs.getString("地址"));%>
									   <br>&nbsp;&nbsp;&nbsp;&nbsp;联系电话：<%out.print(rs.getString("电话"));%>
									   <br>&nbsp;&nbsp;&nbsp;&nbsp;交易时间：<%out.print(rs.getString("时间"));%></div>
			</div>
		<% 
			rs.next();
	}
	%>
	<script language="javascript">
				
				function checkAll(){
				  var names=document.getElementsByName("choose[]");
				  var len=names.length;
				  if(len>0){
					var i=0;
					for(i=0;i<len;i++) names[i].checked=true;
				  }
				}
				 function UNcheckAll(){
				  var names=document.getElementsByName("choose[]");
				  var len=names.length;
				  if(len>0){
					var i=0;
					for(i=0;i<len;i++) names[i].checked=false;
				  }
				}
				 
				</script>
	 	<% 
	
	 	
	 }
 %>
</form>




</div>

</div>
</body>
</html>
