<%-- 
    Document   : tree
    Created on : 23-mar-2008, 14:52:53
    Author     : Wilmer Manzaneda Chavez
--%>
<html>
    <head>
        <script type="text/javascript" src='../js/general.js' ></script> 
        <script type="text/javascript" src='../js/treeComponet.js' ></script>
        <link rel="STYLESHEET" type="text/css" href="../css/treeComponet.css" />
    </head>
    <script>
function parserXMLCodigoBarras(codigo){
    //alert("entrororororor");
    var main= document.getElementById('main');
    var ajax=creaAjax();
    var url='../barcode?codigo='+codigo;
    url+='&pq='+(Math.random()*1000);

    ajax.open ('GET', url, true);
        ajax.onreadystatechange = function() {
         if (ajax.readyState==1) {
            var p=document.createElement('img');
             p.src='../img/load.gif';
             var div=document.createElement('div');
             div.style.paddingTop='150px';
             div.style.paddingLeft='20px';
             div.style.textAlign='center';
             div.style.top='0px';
             div.style.left='0px';
             div.style.position='absolute';
             div.innerHTML='CARGANDO...';
             div.style.fontFamily='Verdana';
             div.style.fontSize='11px';
             div.style.width='200px';
             div.appendChild(p);
             div.style.filter='alpha(opacity=40)';
             main.appendChild(div);
         }else if(ajax.readyState==4){
                    if(ajax.status==200){
                         xml=ajax.responseXML;
                         clearChild(main);
                         xmlResponse();

                   }
                }
        }
        ajax.send(null);
    }
function creaAjax(){
         var objetoAjax=false;
         try {
          /*Para navegadores distintos a internet explorer*/
          objetoAjax = new ActiveXObject("Msxml2.XMLHTTP");
         } catch (e) {
          try {
                   /*Para explorer*/
                   objetoAjax = new ActiveXObject("Microsoft.XMLHTTP");
                   }
                   catch (E) {
                   objetoAjax = false;
          }
         }

         if (!objetoAjax && typeof XMLHttpRequest!='undefined') {
          objetoAjax = new XMLHttpRequest();
         }
         return objetoAjax;
}    
    </script>
    <body onLoad="parserXMLCodigoBarras();">
        <div id="main" style='margin-left:-25px;padding:0px;overflow:auto;'>
            
        </div>
    </body>
</html>
