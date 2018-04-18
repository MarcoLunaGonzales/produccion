
var xml;
var xml2;
nodeIcon=new Image();
nodeIcon2=new Image();
nodeIcon3=new Image();
var srcFolderAbierto = '../img/folderAbierto.jpg';
var srcFolderCerrado = '../img/folderCerrado.jpg';
var srcFormulario = '../img/b.bmp';

function parserXMLUsuariosZeus(codigo){
    var main= document.getElementById('main');
    var ajax=creaAjax();
    var url='../ServletUsuariosZeus?codigo='+codigo;
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
function cargarAccesosSistema(){
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
            icon.src = srcFolderCerrado;
            li.appendChild(icon);
            a.innerHTML=treeNodes[i].attributes[1].nodeValue;
            a.title=treeNodes[i].attributes[1].nodeValue;
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
function xmlResponse(){
    // readXML();
    //alert(xml.getElementsByTagName('iconElement').length);
    nodeIcon.src= xml.getElementsByTagName('iconElement')[0].attributes[0].nodeValue;
    nodeIcon2.src=xml.getElementsByTagName('iconElement')[0].attributes[1].nodeValue;
    nodeIcon3.src=xml.getElementsByTagName('iconElement')[0].attributes[2].nodeValue;
    cargarAccesosSistema();
}

function readXML(){
    var main= document.getElementById('main');
    xml=new ActiveXObject("Microsoft.XMLDOM");
    xml.async='false';
    var url='../arbol?codigo=60';
    xml.load(url);
//xml.load('../config/XMLReponseTree.xml');

}
var nombreDiv="main";
var nombreInputBuscar="nombreVentanaBuscar";
var stylo = " stylo";
var styloBlur = " styloBlur";
var idTdBuscar="idTdBuscarAcceso";
var idTdAccesos =  "idTdAccesos";
var session="";
function buscarAcceso()
{
    clearChild(main);
    var ulBusqueda=document.createElement('ul');
    var liBusqueda=document.createElement('li');
    var a=document.createElement('a');
    a.className='node';
    a.target='mainFrame';
    document.getElementById("main").appendChild(ulBusqueda);
    
    var nombreAcceso=document.getElementById(nombreInputBuscar).value.toLowerCase();
    var accesos=xml.getElementsByTagName('treeNode');
    for(var i=0;(i<accesos.length && nombreAcceso.trim().length>0);i++)
    {
        if ((accesos[i].attributes[1].nodeValue.toLowerCase().indexOf(nombreAcceso) > -1))
        {
            var ul=document.createElement('ul');
            var li=document.createElement('li');
            li.className='n';

            var node=document.createElement('img');
            var folder=document.createElement('img');
            var a=document.createElement('a');
            a.className='node';
            a.target='mainFrame';
            if(accesos[i].attributes[0].nodeValue=='false')
                node.src=nodeIcon3.src;
            else
                node.src=nodeIcon.src;
            li.appendChild(node);
            folder.src = (accesos[i].attributes[6].nodeValue == 'true' ? srcFolderCerrado:srcFormulario);
            li.appendChild(folder);
            li.appendChild(a);
            a.innerHTML=accesos[i].attributes[1].nodeValue;
            a.href=accesos[i].attributes[2].nodeValue+"?session="+session;
            a.title=accesos[i].attributes[1].nodeValue;
            li.id=accesos[i].attributes[3].nodeValue;
            if(accesos[i].attributes[0].nodeValue=='true'){
                node.onclick=function (){
                    onClickEvent(this);
                }
            }
            ul.appendChild(li);
            ulBusqueda.append(ul);
            
        }
            /*
            if(encontrado)
            {
                tablaBuscar.rows[i].style.display = '';
            } else {
                tablaBuscar.rows[i].style.display = 'none';
            }*/
        
    }
}
function onClickBuscar(){
    document.getElementById(nombreInputBuscar).style.display = '';
    document.getElementById(idTdBuscar).style = stylo+styloBlur;
    document.getElementById(idTdAccesos).style = stylo;
    buscarAcceso();
}
function onClickAccesos(){
    clearChild(document.getElementById(nombreDiv));
    cargarAccesosSistema();
    document.getElementById(nombreInputBuscar).style.display = 'none';
    document.getElementById(idTdBuscar).style = stylo;
    document.getElementById(idTdAccesos).style = stylo+styloBlur;
}
function parserXML(){
    
    var main= document.getElementById(nombreDiv);
    var mainContainer = document.getElementById("mainContainer");
    var ajax=creaAjax();
    var url='../servletUsuarios?codigo=60';
    url+='&pq='+(Math.random()*1000);
    ajax.open ('GET', url, true);
    ajax.onreadystatechange = function() {

        if (ajax.readyState==1) {
            var p=document.createElement('img');
            p.src='../img/load2.gif';
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
            //div.style.filter='alpha(opacity=40)';
            main.appendChild(div);
        }else if(ajax.readyState==4){

            if(ajax.status==200){
                xml=ajax.responseXML;
                clearChild(main);
                if(ajax.responseText==''){
                    var p1=document.createElement('img');
                    p1.src='../img/connect_disconnected.gif';
                    var div=document.createElement('div');
                    div.style.paddingTop='150px';
                    div.style.paddingLeft='20px';
                    div.style.textAlign='center';
                    div.style.top='0px';
                    div.style.left='0px';
                    div.style.position='absolute';
                    div.innerHTML='ERROR';
                    div.style.fontFamily='Verdana';
                    div.style.fontSize='11px';
                    div.style.width='200px';
                    div.appendChild(p1);
                     main.appendChild(div);

                }else{
                    var tabla = document.createElement("table");
                    tabla.className='tablaAccesos';
                    
                    tabla.cellpading = '0px';
                    tabla.cellspacing = '0px';
                    var tr = document.createElement("tr");
                    tabla.appendChild(tr);
                    var td =document.createElement("td");
                    td.onclick = function(){onClickAccesos();};
                    td.className = stylo+styloBlur;
                    td.innerHTML="ACCESOS";
                    td.id = idTdAccesos;
                    tr.appendChild(td);
                    
                    var td2 =document.createElement("td");
                    td2.className = stylo;
                    td2.id = idTdBuscar;
                    td2.onclick = function(){onClickBuscar();};
                    tr.appendChild(td2);
                    td2.innerHTML="BUSCAR";
                    var td3 =document.createElement("td");
                    tr.appendChild(td3);
                    td3.width='30%';
                    mainContainer.appendChild(tabla);
                    var input=document.createElement("input");
                    input.id=nombreInputBuscar;
                    input.type='text';
                    input.style.width='85%';
                    input.style.marginLeft='7%';
                    input.style.display='none';
                    input.style.marginBottom='5px';
                    
                    
                    input.onkeyup=function(){buscarAcceso();}
                    main.appendChild(input)
                    xmlResponse();
                }



            }else{
                clearChild(main);
                var p=document.createElement('img');
                
                p.src='../img/connect_disconnected2.gif';
                var div=document.createElement('div');
                div.style.paddingTop='150px';
                div.style.paddingLeft='20px';
                div.style.textAlign='center';
                div.style.top='0px';
                div.style.left='0px';
                div.style.position='absolute';
                //div.innerHTML='CARGANDO...';
                div.style.fontFamily='Verdana';
                div.style.fontSize='11px';
                div.style.width='200px';
                div.appendChild(p);


            }
        }
    }
    ajax.send(null);
}
function clearChild(obj){
    if(obj.hasChildNodes())
        obj.removeChild(obj.lastChild);

}
 
function onClickEvent(element){
    obj=element.parentNode;
    if(element.src==nodeIcon2.src){
        element.parentNode.getElementsByTagName("img")[1].src = srcFolderCerrado;
        element.src=nodeIcon.src;
        clearChild(obj);
    }else{
        element.parentNode.getElementsByTagName("img")[1].src = srcFolderAbierto;
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
                    folder.src = (treeNode[j].attributes[6].nodeValue == 'true' ? srcFolderCerrado:srcFormulario);
                    li.appendChild(folder);
                    li.appendChild(a);
                    a.innerHTML=treeNode[j].attributes[1].nodeValue;
                    a.href=treeNode[j].attributes[2].nodeValue+(treeNode[j].attributes[2].nodeValue.split('?').length > 1?"&":"?")+"session="+session;
                    a.title=treeNode[j].attributes[1].nodeValue;
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