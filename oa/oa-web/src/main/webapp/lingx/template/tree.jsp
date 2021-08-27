<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	org.springframework.context.ApplicationContext spring = org.springframework.web.context.support.WebApplicationContextUtils.getRequiredWebApplicationContext(request.getSession().getServletContext());
	com.lingx.core.service.II18NService i18n=spring.getBean(com.lingx.core.service.II18NService.class);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<base href="<%=basePath%>">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>实体列表</title>
<meta name="renderer" content="webkit">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<%@ include file="/lingx/include/include_JavaScriptAndCssByLayui.jsp"%> 
</head>
<body>
<div id="searchBar" style="height:40px;line-height:40px;padding-left:10px;">
  <button class="layui-btn layui-btn-sm layui-btn-normal" lay-event="lingx-search" style="margin-bottom:0px;" onclick="window.location.reload()">刷新</button>
</div>
<div id="test12" class="demo-tree-more"></div>
              
          
 
<script>

var request_params=${REQUEST_PARAMS};

var fromPageId='${param.pageid}';
var entityCode=request_params.e;
var methodCode=request_params.m;
var entityId='${entityId }';
var params=${_params};

var cmpId='${param.cmpId}';
var LingxOpertor='${param.LingxOpertor}';
var tree,util;
layui.use(['tree', 'util'], function(){
	$.post("e",{e:entityCode,m:"tree",node:0,retType:"layui",lgxsn:1},function(json){
		   tree = layui.tree
		  ,util = layui.util;
		  
		 
		  //基本演示
		  tree.render({
		    elem: '#test12'
		    ,data: json
		    ,onlyIconControl:true
		   // ,showCheckbox: true  //是否显示复选框
		    ,id: 'demoId1'
		    	 ,edit: ['add', 'update', 'del'] //操作节点的图标
		  //  ,isJump: true //是否允许点击节点时弹出新窗口跳转
		    ,click: function(obj){
		      var data = obj.data;  //获取当前点击的节点数据
		     // layer.msg('状态：'+ obj.state + '<br>节点数据：' + JSON.stringify(data));
		      openWindow("树形节点-编辑","e?e="+entityCode+"&m=edit&id="+obj.data.id);
		    }
		  	,operate: function(obj){
		  		var newId=uuid();
		  		if(obj.data.field)window.lingxTreeField=obj.data.field;
		  		$.post("lingx/common/layui_handler.jsp",{c:"tree_opertor",ecode:entityCode,newId:newId,field:obj.data.field||window.lingxTreeField,type:obj.type,title:obj.data.title,id:obj.data.id},function(json){
		  			lgxInfo(json.message);
		  		},"json");
		  		if(obj.type=="add")return newId;
		  	}
		  });
		
	},"json");
});


function lingxSearchIptKeypress(e){
	//console.log(e);
	if(e.keyCode==13){
		lingxSearch();
	}
}
function lingxSearch(){

}
function reloadGrid(){
	window.location.reload()
	//tree.reload('demoId1', {});
}

function uuid() {
	  var temp_url = URL.createObjectURL(new Blob());
	  var uuid = temp_url.toString(); // blob:https://xxx.com/b250d159-e1b6-4a87-9002-885d90033be3
	  URL.revokeObjectURL(temp_url);
	  return uuid.substr(uuid.lastIndexOf("/") + 1);
	}
</script>
</body>

</html>