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
<html  style="height:100%">
<head>
<meta charset="utf-8">
<base href="<%=basePath%>">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>实体列表</title>
<meta name="renderer" content="webkit">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<%@ include file="/lingx/include/include_JavaScriptAndCssByLayui.jsp"%> 
<style type="text/css">
.layui-tab-card>.layui-tab-title{
background-color:#5FB878;
color:#fff;
}

.layui-tab-item{
display:none;
height:100%;
}
</style>
</head>
<body style="height:100%">
<table height='100%' width="100%">
<tr>
<td valign="top" width="300" height='100%'>
<div id="test12" class="demo-tree-more"></div>

</td>
<td valign="top" style="height:100%">
<div lay-filter="demo" class="layui-tab layui-tab-card" style="margin:0px;border-bottom:0px none;">
  <ul class="layui-tab-title" style="padding-left:10px;">
   
  </ul>
  <div class="layui-tab-content" style="padding:0px">
   
  </div>
</div>
</td>
</tr>
</table>
              
 
<script>

var request_params=${REQUEST_PARAMS};

var fromPageId='${param.pageid}';
var entityCode=request_params.e;
var methodCode=request_params.m;
var entityId='${entityId }';
var params=${_params};

var cmpId='${param.cmpId}';
var LingxOpertor='${param.LingxOpertor}';
var entityFields={};
var grid_cascade=${grid_cascade};
var element,tree,util;
layui.use(['element','tree', 'util'], function(){
	$.post("e",{e:entityCode,m:"tree",node:0,retType:"layui",lgxsn:1},function(json){
		element=layui.element,
		   tree = layui.tree
		  ,util = layui.util;
		  //基本演示
		  tree.render({
		    elem: '#test12'
		    ,data: json
		    ,onlyIconControl:true
		  //,showCheckbox: true  //是否显示复选框
		    ,id: 'demoId1'
		    //	 ,edit: ['add', 'update', 'del'] //操作节点的图标
		  //  ,isJump: true //是否允许点击节点时弹出新窗口跳转
		    ,click: function(obj){
		      var data = obj.data;  //获取当前点击的节点数据
		    var el=$(obj.elem[0]);
		      //alert(el.html());
		      $(".layui-tree-main").css("background-color","#fff");
		      $(".layui-tree-txt").css("color","#555555");
		      $(el.find(".layui-tree-main")[0]).css("background-color","#5FB878");
		      $(el.find(".layui-tree-txt")[0]).css("color","#fff");

		      
		      for(var i=0;i<grid_cascade.length;i++){
				  var obj=grid_cascade[i];
				  var url='e?e='+obj.entity+'&m='+obj.method+'&ec=true&rule='+obj.rule+'&'+(obj.rule&&obj.rule!="_none_"?"_refId_":obj.refField)+'='+data.id+"&_refEntity_="+entityCode;
				  $("#"+obj.entity+obj.method)[0].src=url;
			  }
		      
		    },success:function(){
		    	
		    	alert("success");
		    }
		  	
		  });
		
		  for(var i=0;i<grid_cascade.length;i++){
			  var obj=grid_cascade[i];
			  var valId=json[0].id;
			  var url='e?e='+obj.entity+'&m='+obj.method+'&ec=true&rule='+obj.rule+'&'+(obj.rule&&obj.rule!="_none_"?"_refId_":obj.refField)+'='+valId+"&_refEntity_="+entityCode;
			 // alert(url)
			  element.tabAdd('demo', {
			        title: obj.name
			        ,content:'<iframe id="'+obj.entity+obj.method+'" scrolling="auto" frameborder="0" width="100%" height="100%" src="'+url+'"> </iframe>'
			        ,id: obj.entity
			      });
			 if(i==0){
				 element.tabChange('demo', obj.entity);
			 }
		  }
	},"json");
	
	$(".layui-tab-content").height($(window).height()-44);
});
function lingxSubmit(){
	lgxInfo("请单击需要选择的数据！");
}
function lingxSearchIptKeypress(e){
	//console.log(e);
	if(e.keyCode==13){
		lingxSearch();
	}
}
function lingxSearch(){

}
function reloadGrid(){
	tree.reload('demoId1', {
        
      });
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