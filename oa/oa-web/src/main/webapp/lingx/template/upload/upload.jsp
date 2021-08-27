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
<body>
<div id="searchBar" style="height:40px;line-height:40px;padding-left:10px;">
  
</div>
<table class="layui-hide" id="test" lay-filter="test"></table>
 
<script type="text/html" id="toolbarDemo">
<!--
  <div class="layui-btn-container">
    <button class="layui-btn layui-btn-sm" lay-event="getCheckData">获取选中行数据</button>
    <button class="layui-btn layui-btn-sm" lay-event="getCheckLength">获取选中数目</button>
    <button class="layui-btn layui-btn-sm" lay-event="isAll">验证是否全选</button>
  </div>
 -->
</script>
 
<script type="text/html" id="barDemo"><!--
  <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
  <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>-->
</script>
              
          
 
<script>

var request_params={};

var fromPageId='${param.pageid}';
var entityCode="tlingx_file";
var methodCode="grid";
var entityId='${entityId }';
var params={};

var cmpId='${param.cmpId}';
var LingxOpertor='${param.LingxOpertor}';
var type="${param.type}";

var table,upload,json,toolHeight=0,barDemoItem=0;
layui.use(['table','upload'], function(){
   table = layui.table,upload = layui.upload;
  $.post("g",{e:entityCode},function(json1){
	json=eval("(" + json1 + ')');
	//console.log(json);
	var columns=json.columns,columnsNew=[];
	for(var i=0;i<columns.length;i++){
		var obj=columns[i];
		obj.field=obj.dataIndex;
		obj.title=obj.header;
		obj.templet=obj.renderer;
		
		if(!params[obj.dataIndex]){
			columnsNew.push(obj);
		}
	}
	columns=columnsNew;
	//columns.unshift( {type: 'checkbox', fixed: 'left'});
//////搜索栏初始化 start
	var toolbar=json.toolbar;
	var queryParams=json.queryParams;
	var html=$('<div class="layui-btn-container"></div>');
	for(var i=0;i<queryParams.length;i++){
		var obj=queryParams[i];
		html.append('<div class="layui-inline" style="font-size:14px;margin:0px 10px 0px 0px;">'+obj.name+'</div> ');
		html.append('<div class="layui-inline">'+
			    '<input class="layui-input layui-input-sm lingx-search-ipt" style="font-size:14px;width:100px;height:30px;margin:0px 10px 0px 0px;" name="'+obj.code+'" onkeypress="lingxSearchIptKeypress(event)" autocomplete="off">'+
			    '</div> ');
	}
	if(queryParams.length>0){
		html.append('<button class="layui-btn layui-btn-sm layui-btn-normal" lay-event="lingx-search" style="margin-bottom:0px;" onclick="lingxSearch()">搜索</button>');
		toolHeight=40;
	}
	$("#searchBar").append(html);
	
	html=$('<div class="layui-btn-container"></div>');
	for(var i=0;i<toolbar.length;i++){
		var obj=toolbar[i];
		if(obj.currentRow){
			barDemoItem++;
			$("#barDemo").append('<a class="layui-btn layui-btn-xs '+("删除"==obj.text?"layui-btn-danger":"")+'" lay-event="'+obj.code+'">'+obj.text+'</a>');
		}else{
			toolHeight=40;
			$("#searchBar").find(".layui-btn-container").append('<button class="layui-btn layui-btn-sm "  style="margin-bottom:0px;" id="btn_'+obj.code+'">'+obj.text+'</button>');
			$("#searchBar").find("#btn_"+obj.code).bind("click",obj.handler);
			//html.append('<button class="layui-btn layui-btn-sm" lay-event="'+obj.code+'">'+obj.text+'</button>');
		}
	}
	$("#searchBar").find(".layui-btn-container").append('<button class="layui-btn layui-btn-sm "  style="margin-bottom:0px;" id="btn_upload">上传文件</button>');
	//$("#searchBar").find("#btn_upload").bind("click",function(){
	//});
	var uploadInst = upload.render({
	    elem: '#btn_upload' //绑定元素
	    ,url: '<%=basePath %>lingx/template/upload/handler.jsp' //上传接口
	    ,done: function(res){
	    	lgxInfo("文件上传成功");
	    	reloadGrid();
	      //上传完毕回调
	    }
	    ,error: function(){
	      //请求异常回调
	    	lgxInfo("文件上传失败")
	    }
	  });
	
	
	$("#toolbarDemo").append(html);
	/*
	if(!$("#searchBar").find(".layui-btn-container").html()){
		toolHeight=0;
		$("#searchBar").remove();
	}*/
	//搜索栏初始化 end
	
	if(barDemoItem>0)
	columns.push( {fixed: 'right', title:'操作', toolbar: '#barDemo', width:json.GridConfig.toolbarWidth});
	//添加行操作
	
	 var tableIns =table.render({
		    elem: '#test'
		    ,url:Lingx.urlAddParams("e?e="+entityCode+"&m="+methodCode+"&lgxsn=1&retType=layui",params)
		    //,toolbar: toolbar.length>0?'#toolbarDemo':"" //开启头部工具栏，并为其绑定左侧模板
		    ,defaultToolbar: toolbar.length>0?['filter', 'exports', 'print']:[]
		    /*
		    ,defaultToolbar: ['filter', 'exports', 'print', { //自定义头部工具栏右侧图标。如无需自定义，去除该参数即可
		      title: '提示'
		      ,layEvent: 'LAYTABLE_TIPS'
		      ,icon: 'layui-icon-tips'
		    }]
		    */
		    ,height:'full-'+40
	 		,title: '数据列表'
		    ,cols: [columns]
		    ,page: true
		  });
		  
		  //头工具栏事件
		  table.on('toolbar(test)', function(obj){
			  for(var i=0;i<toolbar.length;i++){
				  var o=toolbar[i];
				  if(o.code==obj.event){
					  o.handler();
					  return;
				  }
			  }
		    var checkStatus = table.checkStatus(obj.config.id);
		    switch(obj.event){
		    	case 'lingx-search':
		    		
		    	break;
		      case 'getCheckData':
		        var data = checkStatus.data;
		        layer.alert(JSON.stringify(data));
		      break;
		      case 'getCheckLength':
		        var data = checkStatus.data;
		        layer.msg('选中了：'+ data.length + ' 个');
		      break;
		      case 'isAll':
		        layer.msg(checkStatus.isAll ? '全选': '未全选');
		      break;
		      
		      //自定义头工具栏右侧图标 - 提示
		      case 'LAYTABLE_TIPS':
		        layer.alert('这是工具栏右侧自定义的一个图标按钮');
		      break;
		    };
		  });
		  
		  //监听行工具事件
		  table.on('tool(test)', function(obj){
			  window.CurrentData=[obj];
			  for(var i=0;i<toolbar.length;i++){
				  var o=toolbar[i];
				  if(o.code==obj.event){
					  o.handler();
					  return;
				  }
			  }
		    var data = obj.data;
		    //console.log(obj)
		    if(obj.event === 'del'){
		      layer.confirm('真的删除行么', function(index){
		        obj.del();
		        layer.close(index);
		      });
		    } else if(obj.event === 'edit'){
		      layer.prompt({
		        formType: 2
		        ,value: data.email
		      }, function(value, index){
		        obj.update({
		          email: value
		        });
		        layer.close(index);
		      });
		    }
		  });
		  table.on('row(test)', function(obj){
			    var data = obj.data;
			    //标注选中样式
			    obj.tr.addClass('layui-table-click').siblings().removeClass('layui-table-click');
			    
			  });
		  table.on('rowDouble(test)', function(obj){
			  	//var obj=record.data;
				var val=obj.data["path"];
				var txt=obj.data["name"];
				var win=getFromWindow(fromPageId);
				var objValue=[{text:txt,value:val}];
				if(type=="JSON"){
					win.lingxSet({cmpId:cmpId,text:txt,value:JSON.stringify(objValue)});//val
				}else{
					win.lingxSet({cmpId:cmpId,text:val,value:val});//val
				}
				
				closeWindow();
		  });
  });//,"json"
 
});
function lingxSearchIptKeypress(e){
	//console.log(e);
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
		params[el.attr("name")]="_"+el.val();
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

function lingxSubmit(){
	lgxInfo("请双击需要选择的数据！");
}
</script>
</body>

</html>