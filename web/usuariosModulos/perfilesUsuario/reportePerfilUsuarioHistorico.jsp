<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import="com.cofar.util.*" %>
<html>
    <head>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script src="../../js/general.js"></script>
        <script>
            function returnPage()
            {
                window.location.href='navegadorPerfilesUsuarios.jsf?data='+(new Date()).getTime().toString();;
            }
            function nuevoAjax()
            {	
                var xmlhttp=false;
                try {
                    xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
                } catch (e) {
                    try {
                        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
                    } catch (E) {
                        xmlhttp = false;
                    }
                }
                if (!xmlhttp && typeof XMLHttpRequest!="undefined") {
                    xmlhttp = new XMLHttpRequest();
                }

                return xmlhttp;
            }
            function editarPerfil(codPerfil)
            {
                var ventanas=document.getElementsByName("ventana");
                var codigosVentana=new Array();
                for(var i=0;i<ventanas.length;i++)
                {
                    if(ventanas[i].checked)
                    {
                        codigosVentana.push(ventanas[i].value);
                    }
                }
                ajax=nuevoAjax();
                ajax.open("POST","ajaxGuardarEdicioPerfilesUsuarios.jsf?nombrePerfil="+encodeURIComponent(document.getElementById("nombrePerfil").value)+
                                            "&codEstadoRegistro="+document.getElementById("codEstadoRegistro").value+
                                            "&codPerfil="+codPerfil+
                                            "&a="+(new Date()).getTime().toString(),true);
                ajax.setRequestHeader('content-type', 'application/x-www-form-urlencoded;charset=UTF-8');
                ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        if(ajax.responseText==null || ajax.responseText=='')
                        {
                            alert('No se puede conectar con el servidor, verfique su conexión a internet');
                            return false;
                        }
                        if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                        {
                            alert('Se guardo la edicion del perfil');
                            returnPage();
                            return true;
                        }
                        else
                        {
                            alert("Ocurrio un error al momento de registrar los defectos "+ajax.responseText.split("\n").join(""));
                            return false;
                        }

                    }
                };
                ajax.send("codigosVentana="+codigosVentana);
            }
            function graficarArbol(idDivDibujar)
            {
                var treeNodes=  xmlDoc.getElementsByTagName('treeNode');
                for(var i=0;i<treeNodes.length;i++)
                {
                    var nodeName=treeNodes[i].attributes[3];
                    var ul=document.createElement('ul');
                    ul.id='tree';
                    if(nodeName.nodeValue=='root')
                    {
                        document.getElementById(idDivDibujar).appendChild(ul);
                        var li=document.createElement('li');
                        var icon=document.createElement('img');
                        icon.src='../../img/folder.gif';
                        var a=document.createElement('span');
                        a.className='outputText2';
                        a.className='outputText2';
                        a.innerHTML=treeNodes[i].attributes[1].nodeValue+'  ';
                        var iconMas=document.createElement("img");
                        iconMas.src='../../img/mas.png';
                        iconMas.style.height='16px';
                        iconMas.style.cursor='pointer';
                        iconMas.onclick=function(){seleccionarTodo(this,true);}
                        var iconMenos=document.createElement("img");
                        iconMenos.src='../../img/menos.png';
                        iconMenos.style.height='16px';
                        iconMenos.style.cursor='pointer';
                        iconMenos.onclick=function(){seleccionarTodo(this,false);}
                        li.appendChild(icon)
                        li.appendChild(a);

                        li.id=treeNodes[i].attributes[2].nodeValue;
                        ul.appendChild(li);
                        detalle(li);
                    }
                }
            }
                function detalle(element)
                {
                    var celdas=  xmlDoc.getElementsByTagName('treeNode');
                    var ul=document.createElement('ul');
                    for(var celda =1;celda<=celdas.length-1;celda++)
                    {   
                        if(celdas[celda].attributes[3].nodeValue==element.id)
                        {
                            element.appendChild(ul);
                            var li=document.createElement('li');
                            li.className = celdas[celda].attributes[4].nodeValue;
                            var a=document.createElement('span');
                            a.innerHTML=celdas[celda].attributes[1].nodeValue+'&nbsp;&nbsp;&nbsp;&nbsp;';
                            a.className='outputText2 textoUl';
                            var icon=document.createElement('img');
                            icon.src='../../img/'+(celdas[celda].attributes[0].nodeValue=='true'?'folder.gif':'b.bmp');
                            icon.style.heigth='4px';
                            li.appendChild(icon);
                            li.appendChild(a);
                            li.id=celdas[celda].attributes[2].nodeValue;
                            ul.appendChild(li);
                            if(celdas[celda].attributes[0].nodeValue=='true')
                            {
                                detalle(li);
                            }

                        }
                    }
                }
    
            </script>
        <style type='text/css'>
            li{
                padding: 1px;
                padding-left: 3px !important;
            }
            .eliminado{
                background-color: #ff7171;
            }
            .nuevo{
                background-color: #76e57e;
            }
            .textoUl{
                font-size: 9px;
            }
            .tablaDetalle{
                border-collapse: collapse;
            }
            .tablaDetalle tr td{
                border: 1px solid #b067b1;
                padding: 3px;
            }
            .cabecera{
                background-color: #e8dee4;
                text-align: center;
            }
            .cambioLog{
                background-color: #b067b1;
                color: white;
                text-align: center;
            }
        </style>
    </head>
    <body> 
        <form method="post" action=""  >
            <span class='outputTextTituloSistema'>Historico de trazabilidad</span>
            <table cellpading='0px' align='center' cellspacing='0px' class="tablaDetalle">
                <tbody>
                <%
                    int codPerfil=Integer.valueOf(request.getParameter("codPerfil"));
                    Connection con=null;
                    
                    try
                    {
                        con=Util.openConnection(con);
                        StringBuilder consulta = new StringBuilder("select distinct va.ORDEN,va.COD_VENTANA,va.NOMBRE_VENTANA,va.URL_VENTANA,")
                                                                    .append(" va.COD_VENTANAPADRE,hijo.cantidadRegistros,pavl.COD_PERFIL,pavl2.COD_PERFIL,")
                                                                    .append(" case when pavl.COD_PERFIL is null then 'nuevo' when pavl2.COD_PERFIL is null then 'eliminado' else '' end as estadoRegistro")
                                                            .append(" from VENTANAS_ATLAS va")
                                                                    .append(" left outer join PERFIL_ACCESO_VENTANA_ATLAS_LOG pavl on pavl.COD_VENTANA = va.COD_VENTANA")
                                                                    .append(" and pavl.COD_PERFIL_LOG = ? ")
                                                                    .append(" left outer join PERFIL_ACCESO_VENTANA_ATLAS_LOG pavl2 on pavl2.COD_VENTANA = va.COD_VENTANA")
                                                                    .append(" and pavl2.COD_PERFIL_LOG = ?")
                                                                    .append(" left JOIN ")
                                                                    .append(" (")
                                                                        .append(" select v.COD_VENTANAPADRE,count(*) as cantidadRegistros")
                                                                        .append(" from VENTANAS_ATLAS v")
                                                                        .append(" group by v.COD_VENTANAPADRE")
                                                                    .append(" ) as hijo on hijo.COD_VENTANAPADRE = va.COD_VENTANA")
                                                            .append(" where pavl.COD_PERFIL_LOG is not null or pavl2.COD_PERFIL_LOG is not null")
                                                            .append(" order by va.ORDEN");
                        PreparedStatement pst = con.prepareStatement(consulta.toString());
                        consulta = new StringBuilder("select tpe.NOMBRE_TIPO_PERMISO_ESPECIAL_ATLAS,")
                                                            .append(" case when ppal.COD_PERFIL is null then 'nuevo' when ppal2.COD_PERFIL is null then 'eliminado' else '' end as estadoRegistro")
                                                    .append(" from TIPOS_PERMISOS_ESPECIALES_ATLAS tpe")
                                                        .append(" left outer join PERFILES_PERMISOS_ATLAS_LOG ppal on ppal.COD_TIPO_PERMISO_ESPECIAL_ATLAS= tpe.COD_TIPO_PERMISO_ESPECIAL_ATLAS")
                                                                .append(" and ppal.COD_PERFIL_LOG = ?")
                                                        .append(" left outer join PERFILES_PERMISOS_ATLAS_LOG ppal2 on ppal2.COD_TIPO_PERMISO_ESPECIAL_ATLAS= tpe.COD_TIPO_PERMISO_ESPECIAL_ATLAS")
                                                                .append(" and ppal2.COD_PERFIL_LOG = ?")
                                                    .append(" where ppal.COD_PERFIL_LOG is not null or ppal2.COD_PERFIL_LOG is not null")
                                                    .append(" order by tpe.NOMBRE_TIPO_PERMISO_ESPECIAL_ATLAS");
                        PreparedStatement pstPermisos = con.prepareStatement(consulta.toString());
                        consulta=new StringBuilder("select pua.COD_PERFIL,pua.COD_PERFIL_LOG,pua.NOMBRE_PERFIL,pua.FECHA_TRANSACCION,ttl.NOMBRE_TIPO_TRANSACCION_LOG")
                                                    .append(" ,pua.COD_TIPO_TRANSACCION_LOG,p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal as nombrePersonal")
                                                    .append(" ,er.NOMBRE_ESTADO_REGISTRO,pua.DESCRIPCION_CAUSA_TRANSACCION")
                                            .append(" from PERFILES_USUARIOS_ATLAS_LOG pua")
                                                    .append(" inner join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO = pua.COD_ESTADO_REGISTRO")
                                                    .append(" inner join TIPOS_TRANSACCION_LOG ttl on ttl.COD_TIPO_TRANSACCION_LOG=pua.COD_TIPO_TRANSACCION_LOG")
                                                .append(" inner join personal p on p.COD_PERSONAL = pua.COD_PERSONAL_TRANSACCION")
                                            .append(" where pua.COD_PERFIL = ").append(codPerfil)
                                            .append(" order by pua.FECHA_TRANSACCION");
                        System.out.println("consulta cargar historico de perfil " +consulta.toString());
                        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        ResultSet res=st.executeQuery(consulta.toString());
                        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                        int codPerfilLogAnterior = 0;
                        while(res.next()){
                                out.println("<tr>");
                                    out.println("<td colspan='9'>&nbsp;</td>");
                                out.println("</tr>");
                                out.println("<tr>");
                                    out.println("<td colspan='9' class='outputTextBold cambioLog'>Log "+res.getRow()+"</td>");
                                out.println("</tr>");
                                out.println("<tr>");
                                    out.println("<td class='outputTextBold'>Personal Transacción</td>");
                                    out.println("<td class='outputTextBold'>::</td>");
                                    out.println("<td class='outputText2'>"+res.getString("nombrePersonal")+"</td>");
                                    out.println("<td class='outputTextBold'>Fecha Transacción</td>");
                                    out.println("<td class='outputTextBold'>::</td>");
                                    out.println("<td class='outputText2'>"+sdf.format(res.getTimestamp("FECHA_TRANSACCION"))+"</td>");
                                    out.println("<td class='outputTextBold'>Tipo Transacción</td>");
                                    out.println("<td class='outputTextBold'>::</td>");
                                    out.println("<td class='outputText2'>"+res.getString("NOMBRE_TIPO_TRANSACCION_LOG")+"</td>");
                                out.println("</tr>");
                                out.println("<tr>");
                                    out.println("<td class='outputTextBold'>Observación/Justificación:</td>");
                                    out.println("<td class='outputTextBold'>::</td>");
                                    out.println("<td colspan='7' class='outputText2'>"+res.getString("DESCRIPCION_CAUSA_TRANSACCION")+"</td>");
                                out.println("</tr>");
                                out.println("<tr>");
                                    out.println("<td class='outputTextBold'>Nombre del Perfil</td>");
                                    out.println("<td class='outputTextBold'>::</td>");
                                    out.println("<td class='outputText2'>"+res.getString("NOMBRE_PERFIL")+"</td>");
                                    out.println("<td class='outputTextBold'>Estado</td>");
                                    out.println("<td class='outputTextBold'>::</td>");
                                    out.println("<td class='outputText2'>"+res.getString("NOMBRE_ESTADO_REGISTRO")+"</td>");
                                    out.println("<td colspan='3'>&nbsp;</td>");
                                out.println("</tr>");
                                out.println("<tr>");
                                    out.println("<td colspan='5' style='width:50%' class='cabecera'>Accesos</td>");
                                    out.println("<td colspan='4' style='width:50%' class='cabecera'>Permisos</td>");
                                out.println("</tr>");
                                out.println("<tr>");
                                    out.println("<td colspan='5'><div id='arbolDetalle"+res.getRow()+"'></div></td>");
                                    out.println("<td colspan='4' style='vertical-align:top;padding:0px'><table class='tablaDetalle' style='width:100%'>");
                                            pstPermisos.setInt(1,codPerfilLogAnterior);
                                            pstPermisos.setInt(2, res.getInt("COD_PERFIL_LOG"));
                                            ResultSet resDetalle = pstPermisos.executeQuery();
                                            while(resDetalle.next()){
                                                out.println("<tr>");
                                                    out.println("<td class='outputText2 "+resDetalle.getString("estadoRegistro")+"'>"+resDetalle.getString("NOMBRE_TIPO_PERMISO_ESPECIAL_ATLAS")+"</td>");
                                                out.println("</tr>");
                                            }
                                    out.println("</table></td>");
                                out.println("</tr>");
                                pst.setInt(1, codPerfilLogAnterior);
                                pst.setInt(2, res.getInt("COD_PERFIL_LOG"));
                                resDetalle = pst.executeQuery();
                                StringBuilder xml=new StringBuilder("");
                                xml.append("<tree>");
                                xml.append("<treeNode hasChildNodes=\"true\"  nodeLabel=\"ATLAS\"  nodeName=\""+1+"\" nodeParent=\"root\" check=\"1\"   />");
                                while(resDetalle.next())
                                {
                                    xml.append("<treeNode hasChildNodes=\""+(resDetalle.getInt("cantidadRegistros")>0?"true":"false")+"\"  nodeLabel=\""+resDetalle.getString("NOMBRE_VENTANA")+
                                                "\" nodeName=\""+resDetalle.getInt("COD_VENTANA")+"\" nodeParent=\""+resDetalle.getInt("COD_VENTANAPADRE")+"\" className=\""+resDetalle.getString("estadoRegistro")+"\" />");
                                }
                                xml.append("</tree>");
                                out.println("<script type='text/javascript'>var text, parser, xmlDoc;text='"+xml.toString()+"';");
                                    out.println("parser = new DOMParser();xmlDoc = parser.parseFromString(text,'text/xml');graficarArbol('arbolDetalle"+res.getRow()+"')</script>");
                                
                                codPerfilLogAnterior = res.getInt("COD_PERFIL_LOG");
                        }
                %>
                </tbody>
            </table>
                    
                    <%
                    
                    }
                    catch(Exception ex)
                    {
                        ex.printStackTrace();
                    }
                    finally
                    {
                        con.close();
                    }
                    %>
                    
        </div>
        </form>
        
    </body>
</html>