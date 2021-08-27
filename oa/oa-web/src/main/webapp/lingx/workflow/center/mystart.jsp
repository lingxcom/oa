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
<base href="<%=basePath%>">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>实时监控</title>
<%@ include file="/lingx/include/include_JavaScriptAndCssByLayui.jsp"%> 
<style type="text/css">
.uline{
text-decoration: underline;
}
.layui-table-click{
background-color:#d2fbdd !important;

}

.layui-table-view{
margin:0px 0px 0px 0px;
border-bottom:0px none;
}
</style>
</head>
<body style="height:100%;border:0px none;">
<div id="searchBar" style="height:40px;line-height:40px;padding-left:10px;">
<div class="layui-btn-container"><div class="layui-inline" style="font-size:14px;margin:0px 10px 0px 0px;">流程名称</div> 
<div class="layui-inline"><input class="layui-input layui-input-sm lingx-search-ipt" style="font-size:14px;width:100px;height:30px;margin:0px 10px 0px 0px;" name="name" onkeypress="lingxSearchIptKeypress(event)" autocomplete="off"></div>
<button class="layui-btn layui-btn-sm layui-btn-normal" lay-event="lingx-search" style="margin-bottom:0px;" onclick="lingxSearch()">搜索</button></div>
</div>
<table class="layui-hide" id="test" lay-filter="test" ></table>

<script type="text/html" id="barDemo">
  <a class="layui-btn layui-btn-xs" lay-event="edit">查看</a>
</script>
              
          
 
<script>
var handlerJsp="lingx/workflow/center/handler.jsp";
var table,json;

layui.use('table', function(){
   table = layui.table;
	var columns=[{title:"流程名称",field: 'workflow'},
		{title:"当前任务节点",field: 'task_name',width:150},
		{title:"任务到达时间",field: 'task_time',width:200,templet:function(obj){
			return (obj.task_time)?ft(obj.task_time):"";
		}},
		{title:"流程发起人",field: 'user_name',width:150},
		{title:"流程发起时间",field: 'wf_time',width:200,templet:function(obj){
			return (obj.wf_time)?ft(obj.wf_time):"";
		}}
		];
	
	columns.push( {fixed: 'right', title:'操作', toolbar: '#barDemo', width:180});
	 var tableIns =table.render({
		    elem: '#test'
		    ,url:handlerJsp+'?c=getWorkflowListByFQLayui'
		    ,height:'full-40'
	 		,title: '数据列表'
		    ,cols: [columns]
		    ,page: true
		  });
	 		table.on('row(test)', function(obj){
		    var data = obj.data;
		    //标注选中样式
		    obj.tr.addClass('layui-table-click').siblings().removeClass('layui-table-click');
		    
		  });
		  table.on('rowDouble(test)', function(obj){
			  var data = obj.data;  //获取当前点击的节点数据
			  openFullWindow("w?m=form&_TASK_ID="+data.id);
			});
		  table.on('tool(test)', function(obj){
			    var data = obj.data;
			    if(obj.event === 'edit'){
			    	openFullWindow("w?m=form&_TASK_ID="+data.id);
			    } else if(obj.event === 'wt'){
			    	lgxInfo("打开流程，在左上角“操作”里可委托他人代办")
			    }
			  });
		  
});

function lingxSearchIptKeypress(e){
	if(e.keyCode==13){
		lingxSearch();
	}
}
function lingxSearch(){
	var ipts=$(".lingx-search-ipt");
	var params={isGridSearch:"_true"};
	//console.log(ipts);
	for(var i=0;i<ipts.length;i++){
		var el=$(ipts[i]);
		if(el.val())
		params[el.attr("name")]=el.val();
	}
//alert("lingx-search:"+JSON.stringify(params));
table.reload('test', {page: {
    curr: 1 //重新从第 1 页开始
},where:params});
}
function reloadGrid(){
	table.reload('test', {
        
      });
}
function ft(time){
	return time.substring(0,4)+"-"+time.substring(4,6)+"-"+time.substring(6,8)+" "+time.substring(8,10)+":"+time.substring(10,12)+":"+time.substring(12,14);
}
function closeLI(el,index){
	table.reload('test', {
		url:handlerJsp+'?c='+index
    });
	
}
</script>
</body>
</html>