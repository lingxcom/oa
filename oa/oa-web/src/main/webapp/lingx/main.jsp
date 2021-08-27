<%@page import="com.lingx.core.service.*,java.util.List,java.util.Map"%><%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	org.springframework.context.ApplicationContext spring = org.springframework.web.context.support.WebApplicationContextUtils.getRequiredWebApplicationContext(request.getSession().getServletContext());
	org.springframework.jdbc.core.JdbcTemplate jdbc=spring.getBean("jdbcTemplate",org.springframework.jdbc.core.JdbcTemplate.class);
	com.lingx.core.model.bean.UserBean userBean=(com.lingx.core.model.bean.UserBean)session.getAttribute(com.lingx.core.Constants.SESSION_USER);
	int countMessage1=jdbc.queryForObject("select count(*) from tlingx_message where status='1' and to_user_id=?", Integer.class,userBean.getId());
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta name="renderer" content="webkit" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<meta name="apple-mobile-web-app-status-bar-style" content="black"> 
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="format-detection" content="telephone=no">
<base href="<%=basePath%>">
<title>${SESSION_USER.app.name }</title><!-- ${SESSION_USER.app.name } -->
<%@ include file="/lingx/include/include_JavaScriptAndCssByLayui.jsp"%> 
  <link rel="stylesheet" href="js/layui/css/global.css" media="all">
<script type="text/javascript" src="lingx/js/rootApi_Layui.js?123" charset="UTF-8"></script>
<style type="text/css">
.layui-nav-child .menu_dd a{
padding-left:46px;
text-align:left;
}
.layui-tab-item{
display:none;
height:100%;
}
.layui-tab-card>.layui-tab-title{
background-color:#009688;
color:#fff;
}
.layui-layer-title{
background-color:#009688;
color:#fff;
}
.layui-layer-content{
padding:0px;
margin:0px;
border:0 none;
overflow:hidden !important;
}

.layui-layer-setwin .layui-layer-close {
    background-position: 0px -40px;
}
</style>
<script type="text/javascript">
setInterval("keepSession()", 5*60*1000); //隔5分钟访问一次
function keepSession(){
	$.post("d",{},function(json){
	});
}
</script>
</head>
<body>
<div class="layui-layout layui-layout-admin">
  <div class="layui-header" >
    <div class="layui-logo  layui-bg-black"  style="font-weight:bold;font-size:18px;width:220px;color:#5FB878 !important">${SESSION_USER.app.name }</div>
    <div class="layui-form  component" style="left:230px;" lay-filter="LAY-site-header-component">
    <select id="mainSelect1" lay-search="" lay-filter="select1">
    <option value="">搜索功能模块</option>
    </select>
    <i class="layui-icon layui-icon-search"></i></div>
    <!-- 头部区域（可配合layui 已有的水平导航） -->
    <ul class="layui-nav layui-layout-left" style="display:none;">
      <!-- 移动端显示 -->
      <li class="layui-nav-item layui-show-xs-inline-block layui-hide-sm" lay-header-event="menuLeft">
        <i class="layui-icon layui-icon-spread-left"></i>
      </li>
      
      <li class="layui-nav-item "><a href="javascript:;">nav 1</a></li>
      <li class="layui-nav-item "><a href="javascript:;">nav 2</a></li>
      <li class="layui-nav-item "><a href="javascript:;">nav 3</a></li>
      <li class="layui-nav-item">
        <a href="javascript:;">nav groups</a>
        <dl class="layui-nav-child">
          <dd><a href="javascript:;">menu 11</a></dd>
          <dd><a href="javascript:;">menu 22</a></dd>
          <dd><a href="javascript:;">menu 33</a></dd>
        </dl>
      </li>
    </ul>
    
    <ul class="layui-nav layui-layout-right">
      <li class="layui-nav-item "><a href="javascript:;" onclick="addMsgTab()">站内消息
      <%if(countMessage1>0){
    	  out.println(" <span class=\"layui-badge\">"+countMessage1+"</span>");
      } %>
      </a></li>
      <li class="layui-nav-item layui-hide layui-show-md-inline-block">
        <a href="javascript:;">
          ${SESSION_USER.name }
        </a>
        <dl class="layui-nav-child">
          <dd><a href="javascript:;" onclick='openWindow("个人信息","e?e=tlingx_user&m=editSelf&id=${SESSION_USER.id }")'>个人信息</a></dd>
          <dd><a href="javascript:;" onclick='openWindow("修改密码","e?e=tlingx_user&m=editPassword&id=${SESSION_USER.id }")'>修改密码</a></dd>
          <dd><a href="d?c=logout">退出系统</a></dd>
        </dl>
      </li>
      <!-- 
      <li class="layui-nav-item" lay-header-event="menuRight" lay-unselect>
        <a href="javascript:;">
          <i class="layui-icon layui-icon-more-vertical"></i>
        </a>
      </li> -->
    </ul>
  </div>
  
  <div class="layui-side layui-bg-black" style="width:220px;left:0px;">
    <div class="layui-side-scroll"  style="width:240px;">
      <!-- 左侧导航区域（可配合layui已有的垂直导航） -->
      <ul class="layui-nav layui-nav-tree" lay-filter="test"  style="width:220px;">
       
      </ul>
    </div>
  </div>
  
  <div class="layui-body" style="padding-bottom:0px;left:220px;border:0px none;">
    <!-- 内容主体区域 -->
    <div lay-filter="demo" class="layui-tab layui-tab-card" lay-allowclose="true" style="border:0px none;margin:0px;">
  <ul class="layui-tab-title"  style="padding-left:10px;border:0px none;">
    <li class="layui-this" lay-id="11">系统首页</li>
  </ul>
  <div class="layui-tab-content" style="padding:0px;">
    <div class="layui-tab-item layui-show" style="height:100%;padding:0px;">
<iframe scrolling="auto" frameborder="0" width="100%" height="100%" src="${SESSION_USER.app.indexPage}"> </iframe>
	</div>
  </div>
</div>
  </div>
  <!-- 底部固定区域 
  <div class="layui-footer">
    
    底部固定区域
  </div>-->
</div>
<script>
//JS 
layui.use(['element', 'layer', 'util'], function(){
  var element = layui.element
  ,layer = layui.layer
  ,util = layui.util
  ,$ = layui.$;
  
  //头部事件
  util.event('lay-header-event', {
    //左侧菜单事件
    menuLeft: function(othis){
      layer.msg('展开左侧菜单的操作', {icon: 0});
    }
    ,menuRight: function(){
      layer.open({
        type: 1
        ,content: '<div style="padding: 15px;">处理右侧面板的操作</div>'
        ,area: ['260px', '100%']
        ,offset: 'rt' //右上角
        ,anim: 5
        ,shadeClose: true
      });
    }
  });
  
});
var form=layui.form;
var element = layui.element;
function addTab(id,name,url){
	//alert(id+","+name+","+url)
	if($("#"+id).length==0)
	 element.tabAdd('demo', {
        title: name
        ,content:'<iframe id="'+id+'" scrolling="auto" frameborder="0" width="100%" height="100%" src="'+url+'"> </iframe>'
        ,id: id
      })
      
      element.tabChange('demo', id);
}

window.addEventListener("resize", function(){
	$(".layui-tab-content").height($(window).height()-104);
});

$(function(){
	$(".layui-tab-content").height($(window).height()-104);
	$.post("d",{c:"menu",handler:"no",menu_icon_1:"true"},function(json){
		var menu=$(".layui-nav-tree");
		var html="";
		for(var i=0;i<json.length;i++){
			var obj=json[i];
			//console.log(obj);
			html=$('<li class="layui-nav-item ' +(i==0?"layui-nav-itemed":"")+'"><a href="javascript:;"> '+(obj.iconCls?'<i class="layui-icon '+obj.iconCls+'"></i>':"")+' &nbsp; '+obj.text+'</a><dl class="layui-nav-child"></dl></li>');
			for(var j=0;j<obj.menu.length;j++){
				var o1=obj.menu[j];
				if(o1=="-"){
					html.find("dl").append('<dd class="menu_dd"><hr style="height:1px !important;border:none !important;border-top:1px dotted #393d49 !important;"/></dd>');
				}else{
					html.find("dl").append('<dd class="menu_dd"><a href="javascript:;" onclick="addTab(\''+o1.itemId+'\',\''+o1.text+'\',\''+o1.uri+'\')">'+o1.text+'</a></dd>');
					addSelect(o1.itemId,o1.text,o1.uri);
				}
				
			}
			menu.append(html);
		}
		form.render('select'); 
		layui.element.init();
	},"json");
});

function addMsgTab(){
	addTab("MessageTab","站内消息","e?e=tlingx_message&m=grid");
}
function addSelect(id,text,uri){
	$("#mainSelect1").append("<option  value='"+(id+"|"+text+"|"+uri)+"'>"+text+"</option>");
}

form.on('select(select1)', function(data){
	var temp=data.value;
	var array=temp.split("|");
	addTab(array[0],array[1],array[2]);
  });
</script>
</body>
</html> 