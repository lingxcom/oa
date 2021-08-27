var RootApi=function(){
	var _this=this;
	window.lingxLayerIndexArray=[];
	_this.windowPool=new Array();//对话框缓存池
	_this.messagePool=new Array();//提示消息缓存池
	_this.iframePool=new Array();//iframe内嵌页缓存池,存ID
	_this.searchWindow=null;
	_this.searchCache=null;//查询参数缓存，条件：pageid匹配
	_this.getWidth=function(){
		return $(window).width();
	},
	_this.getHeight=function(){
		return $(window).height();
	},
	_this.getCenterWidth=function(){
		var width=600;
		try{
		width= $(".layui-body").width();
		}catch(e){}
		return width;
	},
	_this.getCenterHeight=function(){
		var height=400;
		try{
			height== $(".layui-body").height();
		}catch(e){}
		return height;
	},
	
	/**
	 * 取出调用主页函数的源Window,从openWindow中找源WIN
	 * @returns
	 */
	_this.getFromWindow=function (id){
		return _this.iteratorIframe(window,id);
	},
	_this.iteratorIframe=function(win,pageid){
		if(!win.getPageID)return null;
		if(win.getPageID()==pageid){
			return win;
		}else{
			var array=$(win.document).find("iframe");//
			var tempWin=null;
			for(var i=0;i<array.length;i++){
				tempWin=_this.iteratorIframe(array[i].contentWindow,pageid);
				if(tempWin)break;
			}
			return tempWin;
		}
	},
	
	_this.urlAddParams=function(url,options){
		if(url.indexOf('?')==-1){
			url+="?1=1";
		}
		for(var t in options){
			url=url+'&'+t+'='+options[t];
		}
		return url;
	},
	/**
	 * 打开对话框
	 * title
	 * url
	 */
	_this.openWindow=function(title,url,pageid){
	
		var id=Lingx.getRandomString(16);
		url=_this.urlAddParams(url,{pageid:pageid});
		
	 window.lingxLayerIndex=layer.open({
        type: 1
        ,title: title //不显示标题栏
        ,closeBtn: true
        ,area: ['720px','480px']
        ,offset:[80]
        ,shade: 0.8
        ,scrollbar: false
        ,maxmin: true
        ,id: id //设定一个id，防止重复弹出
        ,btn: ['确定', '关闭']
        ,btnAlign: 'r'
        ,moveType: 1 //拖拽模式，0或者1
        ,content: '<iframe id="ifr_'+id+'" style="overflow-x:hidden;padding:0px;margin:0px;" scrolling="auto" frameborder="0" width="100%" height="100%" src="'+url+'"> </iframe>'
        ,success: function(layero,index){
         //alert("success");
        },
        yes:function(index, layero, iframe, usedLayer){
        var iframe=$("#ifr_"+id)[0];
       // console.log(iframe);
        if(iframe&&iframe.contentWindow&&iframe.contentWindow.lingxSubmit)iframe.contentWindow.lingxSubmit(index);
       // alert("ok:"+id);
        }
      });
      window.lingxLayerIndexArray.push(window.lingxLayerIndex);
	
	};
	/**
	 * openReadonlyWindow 打开只读对话框
	 */
	_this.openReadonlyWindow=function(title,url,pageid){
		
		return _this.openWindow2(title,url,pageid);
	};
	/**
	 * 打开全屏对话框
	 * title
	 * url
	 */
	_this.openWindowFull=function(title,url,pageid){

		var id=Lingx.getRandomString(16);
		url=_this.urlAddParams(url,{pageid:pageid});
		
	 window.lingxLayerIndex=layer.open({
        type: 1
        ,title: title //不显示标题栏
        ,closeBtn: true
        ,area: ['720px','480px']
        ,offset:[80]
        ,shade: 0.8
        ,scrollbar: false
        ,maxmin: true
        ,id: id //设定一个id，防止重复弹出
        ,btn: ['确定', '关闭']
        ,btnAlign: 'r'
        ,moveType: 1 //拖拽模式，0或者1
        ,content: '<iframe id="ifr_'+id+'" style="overflow-x:hidden;padding:0px;margin:0px;" scrolling="auto" frameborder="0" width="100%" height="100%" src="'+url+'"> </iframe>'
        ,success: function(layero,index){
         //alert("success");
        },
        yes:function(index, layero, iframe, usedLayer){
        var iframe=$("#ifr_"+id)[0];
       // console.log(iframe);
        if(iframe&&iframe.contentWindow&&iframe.contentWindow.lingxSubmit)iframe.contentWindow.lingxSubmit(index);
       // alert("ok:"+id);
        }
      });
      layer.full(window.lingxLayerIndex)
      window.lingxLayerIndexArray.push(window.lingxLayerIndex);
	};
	/**
	 * openReadonlyWindow 打开全屏只读对话框
	 */
	_this.openReadonlyWindowFull=function(title,url,pageid){
		var id=Lingx.getRandomString(16);
		url=_this.urlAddParams(url,{pageid:pageid});
	window.lingxLayerIndex=layer.open({
        type: 1
        ,title: title //不显示标题栏
        ,closeBtn: true
        ,area: ['720px','480px']
        ,offset:[80]
        ,scrollbar: false
        ,shade: 0.8
        ,maxmin: true
        ,id: id //设定一个id，防止重复弹出
        ,btn: [ '关闭']
        ,btnAlign: 'r'
        ,moveType: 1 //拖拽模式，0或者1
        ,content: '<iframe id="ifr_'+id+'" style="overflow-x:hidden;padding:0px;margin:0px;" scrolling="auto" frameborder="0" width="100%" height="100%" src="'+url+'"> </iframe>'
        ,success: function(layero,index){
        //window.layer.index=index;
         //alert("success");
        },
        yes:function(index, layero, iframe, usedLayer){
        layer.close(index);
        }
      });
       layer.full(window.lingxLayerIndex)
      window.lingxLayerIndexArray.push(window.lingxLayerIndex);
      
	};
	_this.openWindow2=function(title,url,pageid){
		var id=Lingx.getRandomString(16);
		url=_this.urlAddParams(url,{pageid:pageid});
	window.lingxLayerIndex=layer.open({
        type: 1
        ,title: title //不显示标题栏
        ,closeBtn: true
        ,area: ['720px','480px']
        ,offset:[80]
        ,scrollbar: false
        ,shade: 0.8
        ,maxmin: true
        ,id: id //设定一个id，防止重复弹出
        ,btn: [ '关闭']
        ,btnAlign: 'r'
        ,moveType: 1 //拖拽模式，0或者1
        ,content: '<iframe id="ifr_'+id+'" style="overflow-x:hidden;padding:0px;margin:0px;" scrolling="auto" frameborder="0" width="100%" height="100%" src="'+url+'"> </iframe>'
        ,success: function(layero,index){
        //window.layer.index=index;
         //alert("success");
        },
        yes:function(index, layero, iframe, usedLayer){
        layer.close(index);
        }
      });
      window.lingxLayerIndexArray.push(window.lingxLayerIndex);
	};
	_this.openWindow3=function(title,url,pageid){
		
		var id=Lingx.getRandomString(16);
		url=_this.urlAddParams(url,{pageid:pageid});
		
	 window.lingxLayerIndex=layer.open({
        type: 1
        ,title: title //不显示标题栏
        ,closeBtn: true
        ,area: ['720px','480px']
        ,offset:[80]
        ,shade: 0.8
        ,scrollbar: false
        ,maxmin: true
        ,id: id //设定一个id，防止重复弹出
        ,btn: ['保存','提交', '关闭']
        ,btnAlign: 'r'
        ,moveType: 1 //拖拽模式，0或者1
        ,content: '<iframe id="ifr_'+id+'" style="overflow-x:hidden;padding:0px;margin:0px;" scrolling="auto" frameborder="0" width="100%" height="100%" src="'+url+'"> </iframe>'
        ,success: function(layero,index){
         //alert("success");
        },
        yes:function(index, layero, iframe, usedLayer){
        var iframe=$("#ifr_"+id)[0];
       // console.log(iframe);
        if(iframe&&iframe.contentWindow&&iframe.contentWindow.lingxSubmit)iframe.contentWindow.lingxSubmit(index);
       // alert("ok:"+id);
        }
      });
      window.lingxLayerIndexArray.push(window.lingxLayerIndex);
	};

	_this.openWindow4=function(title,url,pageid){
	_this.openWindow(title,url,pageid);
	};
	
	/**
	 * 重设对话框的width\height
	 */
	_this.resizeWindow=function(options){
		var win=_this.windowPool.pop();
		if(!win)return;
		if(options.width)win.setWidth(options.width);
		if(options.height)win.setHeight(options.height);
		if(options.top){
			win.setY(options.top);
		}
		if(options.left){
			win.setX(options.left);
		}
		_this.windowPool.push(win);
		return win;
	};
	/**
	 * 获取最前对话框
	 */
	_this.getCurrentDialogWindow=function(){
		var win=_this.windowPool.pop();
		_this.windowPool.push(win);
		return win;
	};
	/**
	 * 重设对话框的top\left\
	 */
	_this.setPosition=function(left,top){
		//lgxInfo("要删除的 rootapi.js setPosition方法");
		var win=_this.windowPool.pop();
		win.setPosition(left,top);
		_this.windowPool.push(win);
		return win;
	};
	/**
	 * 关闭窗口，如果没有参数，为关闭当前窗口
	 */
	_this.closeWindow=function(index){
		layer.close(index||window.lingxLayerIndexArray.pop());
	};
	var a=window.location;
	_this.showMessage=function(msg){
		layer.msg(msg);
	};
	
};


var r=new RootApi();
function isRoot(){return true;}
function getApi(){return r;}