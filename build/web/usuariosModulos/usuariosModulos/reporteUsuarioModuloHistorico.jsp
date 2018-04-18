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
            .modificado{
                background-color: #faffcd;
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
                    int codPersonal=Integer.valueOf(request.getParameter("codPersonal"));
                    int COD_MODULO_ATLAS = 6;
                    Connection con=null;
                    
                    try
                    {
                        con=Util.openConnection(con);
                        StringBuilder consulta = new StringBuilder("select ae.NOMBRE_AREA_EMPRESA,")
                                                                    .append(" case when ual.COD_AREA_EMPRESA is null then 'nuevo' when ual2.COD_AREA_EMPRESA is null then 'eliminado' else ''end as estadoRegistro")
                                                            .append(" from AREAS_EMPRESA ae ")
                                                                    .append(" left outer join USUARIOS_AREA_PRODUCCION_LOG ual on ual.COD_AREA_EMPRESA = ae.COD_AREA_EMPRESA")
                                                                            .append(" and ual.COD_USUARIO_MODULO_LOG = ? ")
                                                                    .append(" left outer join USUARIOS_AREA_PRODUCCION_LOG ual2 on ual2.COD_AREA_EMPRESA = ae.COD_AREA_EMPRESA")
                                                                        .append(" and ual2.COD_USUARIO_MODULO_LOG = ? ")
                                                            .append(" where ual.COD_USUARIO_MODULO_LOG is not null")
                                                                    .append(" or ual2.COD_USUARIO_MODULO_LOG is not null")
                                                            .append(" order by ae.NOMBRE_AREA_EMPRESA");
                        PreparedStatement pst = con.prepareStatement(consulta.toString());
                        consulta = new StringBuilder("select aa.NOMBRE_ALMACENACOND,")
                                                    .append(" case when uacl.cod_almacen is null then 'nuevo' when uacl2.cod_almacen is null then 'eliminado' else ''end as estadoRegistro")
                                            .append(" from ALMACENES_ACOND aa")
                                                    .append(" left outer join usuarios_alamacen_acond_log uacl on uacl.cod_almacen = aa.COD_ALMACENACOND")
                                                    .append(" and uacl.COD_USUARIO_MODULO_LOG = ?")
                                                    .append(" left outer join usuarios_alamacen_acond_log uacl2 on uacl2.cod_almacen = aa.COD_ALMACENACOND")
                                                    .append(" and uacl2.COD_USUARIO_MODULO_LOG = ?")
                                            .append(" where uacl.COD_USUARIO_MODULO_LOG is not null or")
                                                  .append(" uacl2.COD_USUARIO_MODULO_LOG is not null")
                                            .append(" order by aa.NOMBRE_ALMACENACOND");
                        PreparedStatement pstAlmacenes = con.prepareStatement(consulta.toString());
                        System.out.println("consulta detalle almacenes : "+consulta.toString());
                        consulta=new StringBuilder("select uml.COD_PERFIL,uml.COD_USUARIO_MODULO_LOG,pua.NOMBRE_PERFIL,")
                                                        .append(" uml.FECHA_TRANSACCION,ttl.NOMBRE_TIPO_TRANSACCION_LOG,uml.COD_TIPO_TRANSACCION_LOG,")
                                                        .append(" p.AP_PATERNO_PERSONAL + ' ' + p.AP_MATERNO_PERSONAL + ' ' +p.NOMBRES_PERSONAL + ' ' + p.nombre2_personal as nombrePersonal,")
                                                        .append(" er.NOMBRE_ESTADO_REGISTRO,uml.DESCRIPCION_CAUSA_TRANSACCION")
                                                        .append(" ,uml.NOMBRE_USUARIO,UML.COD_ESTADO_REGISTRO,uml2.*")
                                                 .append(" from USUARIOS_MODULOS_LOG uml")
                                                            .append(" inner join TIPOS_TRANSACCION_LOG ttl on ttl.COD_TIPO_TRANSACCION_LOG =uml.COD_TIPO_TRANSACCION_LOG")
                                                            .append(" inner join personal p on p.COD_PERSONAL = uml.COD_PERSONAL_TRANSACCION")
                                                            .append(" left outer join PERFILES_USUARIOS_ATLAS pua on pua.COD_PERFIL = uml.COD_PERFIL")
                                                            .append(" left outer join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO =uml.COD_ESTADO_REGISTRO")
                                                            .append(" outer APPLY(")
                                                                    .append(" select top 1 um.COD_ESTADO_REGISTRO as COD_ESTADO_REGISTRO2,um.COD_USUARIO_MODULO_LOG as COD_USUARIO_MODULO_LOG2")
                                                                        .append(" ,um.NOMBRE_USUARIO as NOMBRE_USUARIO2, um.COD_PERFIL  AS COD_PERFIL2")
                                                                    .append(" from  USUARIOS_MODULOS_LOG um ")
                                                                    .append(" where um.COD_PERSONAL = uml.COD_PERSONAL")
                                                                            .append(" and um.COD_MODULO = uml.COD_MODULO")
                                                                        .append(" and um.FECHA_TRANSACCION <  uml.FECHA_TRANSACCION")
                                                                    .append(" order by um.FECHA_TRANSACCION desc")
                                                            .append(" ) as uml2")
                                                 .append(" where uml.COD_PERSONAL = ").append(codPersonal)
                                                         .append(" and uml.COD_MODULO = ").append(COD_MODULO_ATLAS)
                                                 .append(" order by uml.FECHA_TRANSACCION");
                        System.out.println("consulta CARGAR HISTORICO USUARIO:  " +consulta.toString());
                        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        ResultSet res=st.executeQuery(consulta.toString());
                        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                        int codUsuarioModuloLogAnterior = 0;
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
                                    out.println("<td class='outputTextBold'>NOMBRE USUARIO</td>");
                                    out.println("<td class='outputTextBold'>::</td>");
                                    out.println("<td class='outputText2 "+(res.getString("NOMBRE_USUARIO").equals(res.getString("NOMBRE_USUARIO2")) ? "" : "modificado")+"'>"+res.getString("NOMBRE_USUARIO")+"</td>");
                                    out.println("<td class='outputTextBold'>PERFIL</td>");
                                    out.println("<td class='outputTextBold'>::</td>");
                                    out.println("<td class='outputText2 "+(res.getInt("COD_PERFIL") == res.getInt("COD_PERFIL2") ? "" : "modificado")+"'>"+res.getString("NOMBRE_PERFIL")+"</td>");
                                    out.println("<td class='outputTextBold'>ESTADO</td>");
                                    out.println("<td class='outputTextBold'>::</td>");
                                    out.println("<td class='outputText2 "+(res.getInt("COD_ESTADO_REGISTRO") == res.getInt("COD_ESTADO_REGISTRO2") ? "" : "modificado")+"'>"+res.getString("NOMBRE_ESTADO_REGISTRO")+"</td>");
                                out.println("</tr>");
                                out.println("<tr>");
                                    out.println("<td colspan='5' style='width:50%' class='cabecera'>AREAS HABILITADAS</td>");
                                    out.println("<td colspan='4' style='width:50%' class='cabecera'>ALMACENES HABILITADOS</td>");
                                out.println("</tr>");
                                out.println("<tr>");
                                    out.println("<td colspan='5' style='vertical-align:top;padding:0px'><table class='tablaDetalle' style='width:100%'>");
                                            pst.setInt(1, codUsuarioModuloLogAnterior);
                                            pst.setInt(2, res.getInt("COD_USUARIO_MODULO_LOG"));
                                            ResultSet resDetalle = pst.executeQuery();
                                            while(resDetalle.next())
                                            {
                                                out.println("<tr>");
                                                    out.println("<td class='outputText2 "+resDetalle.getString("estadoRegistro")+"'>"+resDetalle.getString("NOMBRE_AREA_EMPRESA")+"</td>");
                                                out.println("</tr>");
                                            }
                                    out.println("</table></td>");
                                    out.println("<td colspan='4' style='vertical-align:top;padding:0px'><table class='tablaDetalle' style='width:100%'>");
                                            pstAlmacenes.setInt(1,codUsuarioModuloLogAnterior);
                                            pstAlmacenes.setInt(2, res.getInt("COD_USUARIO_MODULO_LOG"));
                                            resDetalle = pstAlmacenes.executeQuery();
                                            while(resDetalle.next()){
                                                out.println("<tr>");
                                                    out.println("<td class='outputText2 "+resDetalle.getString("estadoRegistro")+"'>"+resDetalle.getString("NOMBRE_ALMACENACOND")+"</td>");
                                                out.println("</tr>");
                                            }
                                    out.println("</table></td>");
                                out.println("</tr>");
                                
                                codUsuarioModuloLogAnterior = res.getInt("COD_USUARIO_MODULO_LOG");
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