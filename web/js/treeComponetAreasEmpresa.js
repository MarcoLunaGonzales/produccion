
/*
 *  Created on 5 de Marzo de 2008, 18:24
 *  @author 
 *  @group ISAWI
*/
 var xml;
 nodeIcon=new Image();
 nodeIcon2=new Image();
 nodeIcon3=new Image();
 
  function readXML(){
        xml=new ActiveXObject("Microsoft.XMLDOM");
		xml.async='false';
                //xml.load('../organigramaempresa?codigo=60');
                xml.load('../organigramaempresa');
		//xml.load('../config/XMLReponseTree.xml');
                
	}
  function parserXML(){
 	  var main= document.getElementById('main');
          readXML();
          nodeIcon.src= xml.getElementsByTagName('iconElement')[0].attributes[0].nodeValue;
          nodeIcon2.src=xml.getElementsByTagName('iconElement')[0].attributes[1].nodeValue;
		  nodeIcon3.src=xml.getElementsByTagName('iconElement')[0].attributes[2].nodeValue;
		var treeNodes=  xml.getElementsByTagName('treeNode');	
	   	var size=treeNodes.length;
	   
	    var ul=document.createElement('ul');
		ul.id='tree';
		
		for(var i=0;i<size;i++){
			var nodeName=treeNodes[i].attributes[4];		
			if(nodeName.nodeValue=='root'){
				var li=document.createElement('li');
				var a=document.createElement('a');
                                 a.className='node';
                                 a.target='mainFrame';
				var node=document.createElement('img');
				var icon=document.createElement('img');
				node.src=nodeIcon.src;
				li.appendChild(node);
                icon.src=treeNodes[i].attributes[5].nodeValue;
				li.appendChild(icon);
				a.innerHTML=treeNodes[i].attributes[1].nodeValue;
				a.href='#';
				li.appendChild(a);
				li.id=treeNodes[i].attributes[3].nodeValue;
				node.onclick=function(){
				 onClickEvent(this);
				}
				ul.appendChild(li);
			}
		}
		main.appendChild(ul);
    
  }
  function clearChild(obj){
            if(obj.hasChildNodes())
                obj.removeChild(obj.lastChild);
   }
   
    function onClickEvent(element){
	
            obj=element.parentNode;
		    if(element.src==nodeIcon2.src){
         			element.src=nodeIcon.src;
				   clearChild(obj);
			}else{
					element.src=nodeIcon2.src;
					var treeNode=xml.getElementsByTagName('treeNode');
					var ul=document.createElement('ul');
		for(var j=0;j<treeNode.length;j++){
		     if(treeNode[j].attributes[4]!=null){
		  		if(treeNode[j].attributes[4].nodeValue==obj.id){
						var li=document.createElement('li');
                                                 li.className='n';
                                                 
						var node=document.createElement('img');						
						var folder=document.createElement('img');						
						var a=document.createElement('a');
                                                 a.className='node';
                                                 a.target='mainFrame';
						if(treeNode[j].attributes[0].nodeValue=='false')
						  	node.src=nodeIcon3.src;	
						else
 						   node.src=nodeIcon.src;
						li.appendChild(node);
						folder.src=treeNode[j].attributes[5].nodeValue;
						li.appendChild(folder);
						li.appendChild(a);
						a.innerHTML=treeNode[j].attributes[1].nodeValue;
						a.href=treeNode[j].attributes[2].nodeValue;
						li.id=treeNode[j].attributes[3].nodeValue;
						ul.appendChild(li);
						
						if(treeNode[j].attributes[0].nodeValue=='true'){
							node.onclick=function (){
						    onClickEvent(this);
						    }
						}
 					}
		 	}
	}
	obj.appendChild(ul);
	}
  }
