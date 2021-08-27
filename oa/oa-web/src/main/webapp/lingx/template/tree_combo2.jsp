<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	org.springframework.context.ApplicationContext spring = org.springframework.web.context.support.WebApplicationContextUtils.getRequiredWebApplicationContext(request.getSession().getServletContext());
	com.lingx.core.service.II18NService i18n=spring.getBean(com.lingx.core.service.II18NService.class);
	String text="";
	if(request.getParameter("text")!=null)text=java.net.URLDecoder.decode(request.getParameter("text"),"UTF-8");
	request.setAttribute("reqText",text);
%>
<!DOCTYPE html>
<html style="height:100%">
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
.item_checked{
background-color: #5FB878!important;
color: #fff!important;
-webkit-user-select:none;
-moz-user-select:none;
-ms-user-select:none;
user-select:none;
}

</style>
</head>
<body style="height:100%">
<table style="width:100%;height:100%">
<tr>
<td  valign="top" width="170">
<div style="width:170px;height:100%;border-right:1px solid #eee;overflow:auto;overflow-x:hidden;">
 <ul class="layui-menu" id="demo1">
      
        
</ul>
</div>
</td><td valign="top">
<div id="test12" class="demo-tree-more"></div>
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
var tree,util;
var oldtext="${reqText}";
var oldvalue="${param.value}";
layui.use(['tree', 'util'], function(){
	$.post("e",{e:entityCode,m:"tree",node:0,retType:"layui",lgxsn:1},function(json){
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
		      if($("#item_"+obj.data.id).length>0){
		    	  lgxInfo("该项已选择，双击左栏可删除！")
		    	  return;
		      }
		      $("#demo1").append('<li id="item_'+obj.data.id+'" item-value="'+obj.data.id+'" item-title="'+obj.data.title+'" style="background-color:#5FB878!important"  class="item_checked" ondblclick="closeLI(this)"><div class="layui-menu-body-title">'+obj.data.title+'</div></li>');
		      //var win=getFromWindow(fromPageId);
				//win.lingxSet({cmpId:cmpId,text:obj.data.title,value:obj.data.id});
				//closeWindow();
		    }
		  	
		  });
		
		  if(oldtext){
			  var arr1=oldtext.split(",");
			  var arr2=oldvalue.split(",");
			  for(var i=0;i<arr1.length;i++){
				  var id=arr2[i],title=arr1[i];
				  $("#demo1").append('<li id="item_'+id+'" item-value="'+id+'" item-title="'+title+'" style="background-color:#5FB878!important"  class="item_checked" ondblclick="closeLI(this)"><div class="layui-menu-body-title">'+title+'</div></li>');
			      
			  }
		  }
	},"json");
});
function lingxSubmit(){
	var els=$(".item_checked"),texts="",values="";
	for(var i=0;i<els.length;i++){
		texts+=$(els[i]).attr("item-title")+',';
		values+=$(els[i]).attr("item-value")+',';
	}
	if(els.length>0){
		texts=texts.substring(0,texts.length-1);
		values=values.substring(0,values.length-1);
	}
	var win=getFromWindow(fromPageId);
	win.lingxSet({cmpId:cmpId,text:texts,value:values});
	closeWindow();
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

function closeLI(el){
	$(el).remove();
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