package biblioteca.cuestionariosPersonal;

<%@page contentType="text/html"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.sql.Statement"%>
<%@ page import="com.cofar.util.*" %>
<%@ page language="java" import="java.util.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<html >
    <head>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script src="../../js/general.js"></script>
        <style>
        
            .headerC{
                font-weight:bold;
                font-size:14px;
                color:white;
                background-color:#9d5a9e;
                padding:3px;
            }
            .pregunta
            {
                font-size:14px;
                font-weight:bold;
                padding-top:5px;
                padding-bottom:5px;
            }

            .respuesta
            {
                font-size:12px;
                padding-left:6px;
                padding-right:7px;
                padding-top:5px;
                padding-bottom:5px;
            }
            
            .preguntaCell
            {
                padding-left:7px;
                padding-right:7px;
                padding-top:12px;
                padding-bottom:7px;
            }
            .buttonGuardar
            {
                color:#ffffff;
                background-color:#9d5a9e;
                border:1px solid black;
                margin-left:1px;
                margin-top:4px;
                margin-bottom:6px;
            }
        </style>
        <script>
            var contPopup=0;
               function verDocumento(url1,impresion,guardado){
                    izquierda = (screen.width) ? (screen.width-300)/2 : 100
                    arriba = (screen.height) ? (screen.height-400)/2 : 200
                    var url='../../mostrarDocumento?codP='+Math.random()+'&srce='+url1+'&i='+impresion+'&g='+guardado;
                     opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,width=700,height=400,left='+izquierda+ ',top=' + arriba + ''
                     contPopup++;
                     window.open(url, ('popUp'+contPopup),opciones);
                     

                }
                function nuevoAjax()
                {	var xmlhttp=false;
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
                function guardarResultados()
                {
                    var tabla=document.getElementById("cuestionario");
                    var respuestasPreg=new Array();
                    var cont=0;
                    for(var i=1;i<tabla.rows.length-1;i+=2)
                        {
                            if(parseInt(tabla.rows[i].cells[0].getElementsByTagName('input')[0].value)==1)
                                {
                                    
                                    if(tabla.rows[i+1].cells[1].getElementsByTagName('table').length>0)
                                        { 
                                            var tabla1=tabla.rows[i+1].cells[1].getElementsByTagName('table')[0];
                                            
                                            respuestasPreg[cont]="p-"+tabla.rows[i].cells[1].getElementsByTagName('input')[0].value+"-f-"+tabla1.rows.length;
                                            cont++;
                                            for(var j=0;j<tabla1.rows.length;j++)
                                                {
                                                    respuestasPreg[cont]=tabla1.rows[j].cells[1].getElementsByTagName('input')[0].value;
                                                    cont++;
                                                    respuestasPreg[cont]=(tabla1.rows[j].cells[0].getElementsByTagName('input')[0].checked?"1":"0");
                                                    cont++;
                                                }
                                        }
                                        else
                                            {
                                            respuestasPreg[cont]="p-"+tabla.rows[i].cells[1].getElementsByTagName('input')[0].value+"-f-0";
                                            cont++;
                                            }
                                }
                            else
                                {
                                    respuestasPreg[cont]="p-"+tabla.rows[i].cells[1].getElementsByTagName('input')[0].value+"-f-texto";
                                    cont++;
                                    var ale=tabla.rows[i+1].cells[1].getElementsByTagName('textarea')[0].value;
                                    respuestasPreg[cont]=(ale == '' ? '_':ale).split(",").join("æ");
                                    cont++;
                                }
                        }
                        ajax=nuevoAjax();
                        ajax.open("GET","ajaxGuardarRevisado.jsf?codDoc="+document.getElementById('codDocumento').value+"&codPersonal="+document.getElementById("codPersonal").value+"&preguntas="+respuestasPreg+
                        "&a="+Math.random(),true);
                        ajax.onreadystatechange=function(){
                            if (ajax.readyState==4) {
                                if(ajax.responseText==null || ajax.responseText=='')
                                {
                                    alert('No se puede conectar con el servidor, verfique su conexión a internet');
                                   /* document.getElementById('formsuper').style.visibility='hidden';
                                    document.getElementById('divImagen').style.visibility='hidden';*/
                                    return false;
                                }
                                if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                                {
                                    window.location.href='navegadorDocumentosPersonal.jsf';
                                    alert('Se registraron las respuestas');
                                    /*document.getElementById('formsuper').style.visibility='hidden';
                                    document.getElementById('divImagen').style.visibility='hidden';*/
                                    return true;
                                }
                                else
                                {
                                    alert("Ocurrio un error al momento de registrar las respuestas"+ajax.responseText.split("\n").join(""));
                                    /*document.getElementById('formsuper').style.visibility='hidden';
                                    document.getElementById('divImagen').style.visibility='hidden';*/
                                    return false;
                                }

                            }
                        }

                        ajax.send(null);
                        
                }
           </script>
    </head>
    <body style="border:none;" ><br><br>
        <h3 align="center"></h3>
            
        <form name="upform" method="post" action="agregarDocumentacionBiblioteca.jsf" enctype="multipart/form-data">
            <div align="center">

                    <%
                    try
                    {
                     
                        Connection con=null;
                        con=Util.openConnection(con);
                         String codCuestionario=request.getParameter("codCuestionario");
                         String codPersonal=request.getParameter("codPersonal");
                         String consulta="select cc.NOMBRE_CUESTIONARIO,cc.TIEMPO_CUESTIONARIO"+
                                         " from cuestionarios_cargo cc where cc.COD_CUESTIONARIO_CARGO='"+codCuestionario+"'";
                         System.out.println("consulta cargar Datos "+consulta);
                         Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                         ResultSet res=st.executeQuery(consulta);
                         consulta=" select dp.COD_PREGUNTA,d.COD_DOCUMENTO from DOCUMENTACION d  inner join DOCUMENTACION_PREGUNTAS dp on dp.COD_DOCUMENTO=d.COD_DOCUMENTO"+
                                         " where "+(codMaquina.equals("0")?"d.cod_compprod='"+codComprod+"'":" d.COD_MAQUINA='"+codMaquina+"' ")+" and dp.COD_ESTADO_REGISTRO=1"+
                                         " order by d.COD_DOCUMENTO";
                        System.out.println("consulta aleatorio "+consulta);
                        List<String> codArray=new ArrayList<String>();
                        res=st.executeQuery(consulta);
                        while(res.next())
                        {
                            codArray.add(res.getString("COD_PREGUNTA")+","+res.getString("COD_DOCUMENTO"));
                        }
                        System.out.println(nroPreguntas);
                        if(codArray.size()<Integer.valueOf(nroPreguntas))
                        {

                            con.close();
                            out.println("<script>alert('No se han cargado las suficientes preguntas para el cuestionario');window.location.href='navegadorDocumentosPersonal.jsf';</script>");
                        }
                        else
                        {
                            consulta="select C.COD_CUESTIONARIO_CARGO,c.nombre_cuestionario," +
                                        "isnull(cp.cod_compprod,0) as cod_compprod,isnull(cp.nombre_prod_semiterminado,'') as nombre_prod_semiterminado," +
                                        "isnull(m.cod_maquina,0) as cod_maquina,isnull(M.NOMBRE_MAQUINA,'') as NOMBRE_MAQUINA,C.nro_preguntas,C.preg_aleatorias,C.fecha_cuestionario,c.fecha_inicio,c.fecha_final,cg.codigo_cargo,cg.descripcion_cargo," +
                                        " (p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal ) as nombrePersonal" +
                                        " from CUESTIONARIOS_CARGO c "+
                                        " inner join CARGOS cg on cg.CODIGO_CARGO = c.COD_CARGO "+
                                        " left outer join COMPONENTES_PROD cp on cp.COD_COMPPROD = c.cod_compprod"+
                                        " left outer join MAQUINARIAS m on m.COD_MAQUINA = c.cod_maquinaria"+
                                        " inner join PERSONAL p on p.CODIGO_CARGO=cg.CODIGO_CARGO"+
                                        " where p.COD_PERSONAL='"+codPersonal+"'"+(codComprod.equals("0")?" and m.cod_maquina='"+codMaquina+"'":" and cp.cod_compprod='"+codComprod+"'");
                                    System.out.println("consulta cabecera "+consulta);
                                    res=st.executeQuery(consulta);
                                    if(res.next())
                                    {
                                        %>
                                          <table cellpadding="0" cellspacing="0" style="border:1px solid black">
                                                <tr>
                                                    <td  align="center" style="border-bottom: 1px solid black" colspan="4" class="headerC outputText2" >Datos Cuestionario</td>
                                                </tr>
                                                <tr>

                                                    <td style="padding:3px;"><span style="font-weight:bold;" class="outputText2">NOMBRE</span></td>
                                                    <td style="padding:3px;"><span style="font-weight:bold;" class="outputText2">::</span></td>
                                                    <td style="padding:3px;"><span class="outputText2"><%=res.getString("nombre_cuestionario")%></span></td>
                                                </tr>
                                                <tr>
                                                   
                                                    <td style="padding:3px;"><span style="font-weight:bold;" class="outputText2">PRODUCTO</span></td>
                                                    <td style="padding:3px;"><span style="font-weight:bold;" class="outputText2">::</span></td>
                                                    <td style="padding:3px;"><span class="outputText2"><%=res.getString("nombre_prod_semiterminado")%></span></td>
                                                </tr>
                                                <tr>
                                                    <td style="padding:3px;"><span style="font-weight:bold;" class="outputText2">Maquina</span></td>
                                                    <td style="padding:3px;"><span style="font-weight:bold;" class="outputText2">::</span></td>
                                                    <td style="padding:3px;"><span class="outputText2"><%=res.getString("NOMBRE_MAQUINA")%></span></td>
                                                </tr>
                                                <tr>
                                                    <td style="padding:3px;"><span style="font-weight:bold;" class="outputText2">Personal</span></td>
                                                    <td style="padding:3px;"><span style="font-weight:bold;" class="outputText2">::</span></td>
                                                    <td style="padding:3px;"><span class="outputText2"><%=res.getString("nombrePersonal")%></span></td>
                                                </tr>
                                                
                                          </table>
                                          <input type="hidden" value="<%=codDocumento%>" id="codDocumento"/>
                                          <input type="hidden" value="<%=codPersonal%>" id="codPersonal"/>
                                        <%
                                    }
                            %>
                        <table cellpadding="0" id="cuestionario" cellspacing="0" style="border:1px solid black;margin-top:12px;">
                                <tr>
                                    <td  align="center" style="border-bottom: 1px solid black" colspan="2" class="headerC outputText2" >Cuestionario</td>
                                    

                                </tr>
                  
                            <%    List<String> aleatorio=new ArrayList<String>();
                                while(aleatorio.size()!=(Integer.valueOf(nroPreguntas)))
                                {
                                    int nro=(int)(Math.random()*codArray.size());
                                    aleatorio.add(codArray.get(nro));
                                    codArray.remove(nro);
                                }
                                int cont=0;
                                System.out.println(aleatorio.size());
                                for(String codPregunta:aleatorio)
                                {
                                    cont++;
                                    consulta="select dp.COD_PREGUNTA,dr.COD_RESPUESTA,dp.DESCRIPCION_PREGUNTA,dr.DESCRIPCION_RESPUESTA,dp.PREGUNTA_CERRADA"+
                                             " from DOCUMENTACION_PREGUNTAS dp left outer join DOCUMENTACION_RESPUESTAS dr on"+
                                             " dp.COD_DOCUMENTO=dr.COD_DOCUMENTO and dp.COD_PREGUNTA=dr.COD_PREGUNTA and dr.COD_ESTADO_REGISTRO=1"+
                                             " where dp.COD_DOCUMENTO='"+codPregunta.split(",")[1]+"' and dp.COD_PREGUNTA='"+codPregunta.split(",")[0]+"' ";
                                    System.out.println("consulta pregunta "+consulta);
                                    res=st.executeQuery(consulta);
                                    boolean preguntaCerrada=false;
                                    boolean sinrepuesta=false;
                                    if(res.next())
                                    {
                                        out.println("<tr><td class='preguntaCell'><input type='hidden' value='"+res.getString("PREGUNTA_CERRADA")+"'/><span class='outputText2 pregunta'>"+cont+"</span></td> " +
                                                "<td class='preguntaCell'><input type='hidden' value='"+res.getString("COD_PREGUNTA")+"'><span class='outputText2 pregunta'>"+res.getString("DESCRIPCION_PREGUNTA")+"</span><br/></td></tr>");
                                        out.println("<tr><td></td>");
                                        preguntaCerrada=res.getInt("PREGUNTA_CERRADA")>0;
                                        sinrepuesta=res.getString("DESCRIPCION_RESPUESTA")==null;
                                        out.println(preguntaCerrada?(sinrepuesta?"<td class='outputText2'>No se cargaron Respuestas</td></tr>":
                                            "<td><table cellpadding='0' cellspacing='0' ><tr><td><input type='checkbox'></td><td class='outputText2 respuesta'><input type='hidden' value='"+res.getString("COD_RESPUESTA")+"'/>"+res.getString("DESCRIPCION_RESPUESTA")+"</td></tr>"):
                                            "<td class='outputText2 respuesta'><textarea rows='3' cols='60'></textarea></td></tr>");
                                    }
                                    while(res.next())
                                    {
                                        out.println("<tr><td><input type='checkbox'></td><td class='outputText2 respuesta'><input type='hidden' value='"+res.getString("COD_RESPUESTA")+"'/>"+res.getString("DESCRIPCION_RESPUESTA")+"</td></tr>");
                                    }
                                    out.println((preguntaCerrada&&!sinrepuesta)?"</table></td> </tr>":"");
                                }
                                
                        }
                        res.close();
                        st.close();
                        con.close();
                    }
                    catch(SQLException ex)
                    {
                        ex.printStackTrace();
                    }
                    %>
                    <tr>
                       <td colspan="2" align="center">
                           <%--button class="buttonGuardar" onclick="guardarResultados();" >Guardar</button--%>
                        <button class="buttonGuardar" onclick="window.location.href='navegadorCuestionariosCargoPersonal.jsf'">Cancelar</button>
                       </td>
                    </tr>
            </table>
                  
            </div>
        </form>
        <script type="text/javascript" language="JavaScript"  src="../../js/dlcalendar.js" ></script>
    </body>
</html>