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
<%@page import="java.text.NumberFormat" %>
<%@page import="java.text.DecimalFormat" %>
<%@page import="java.util.Locale" %>
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
            .correcta
            {
                background-color:#90EE90;
            }
            .incorrecta
            {
                background-color:#E9967A;
            }
            .celdaRespuesta
            {
                padding-top:12px;
                border-left:1px solid black;
                text-align:center;
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
                function showModal()
                {
                    var a=document.getElementById('formsuper').style;
                    a.visibility='visible';
                    a.width=window.document.body.scrollWidth;
                    a.height=window.document.body.scrollHeight;
                }
                function hideModal()
                {
                    document.getElementById('formsuper').style.visibility='hidden';
                }
                function guardarCalificacion()
                {
                    var tabla=document.getElementById("cuestionario");
                    var calificacionPreg=new Array();
                    showModal();
                    var cont=0;
                    for(var i=1;i<tabla.rows.length;i+=2)
                        {
                            calificacionPreg[cont]=tabla.rows[i].cells[1].getElementsByTagName('input')[0].value;
                            cont++
                            calificacionPreg[cont]=tabla.rows[i].cells[2].getElementsByTagName('input')[0].value==''?0:tabla.rows[i].cells[2].getElementsByTagName('input')[0].value;
                            cont++;
                        }
                        ajax=nuevoAjax();
                        ajax.open("GET","ajaxGuardarCalificacionCuestionario.jsf?codCuestionario="+document.getElementById('codCuestionario').value+
                                  "&calificacion="+calificacionPreg+"&a="+Math.random(),true);
                        ajax.onreadystatechange=function(){
                            if (ajax.readyState==4) {
                                if(ajax.responseText==null || ajax.responseText=='')
                                {
                                    alert('No se puede conectar con el servidor, verfique su conexión a internet');
                                    hideModal();
                                    return false;
                                }
                                if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                                {
                                    alert('Se registraron las respuestas');
                                    window.close();
                                    return true;
                                }
                                else
                                {
                                    alert("Ocurrio un error al momento de registrar las respuestas"+ajax.responseText.split("\n").join(""));
                                    hideModal();
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
            <div  id="formsuper"  style="
                padding: 50px;
                background-color: #cccccc;
                position:absolute;
                z-index: 1;
                left:0px;
                top: 0px;
                border :2px solid #3C8BDA;
                width :100%;
                height: 100%;
                filter: alpha(opacity=70);
                visibility:hidden;
                opacity: 0.8;" >
          </div>
            <div align="center">

                    <%
                    try
                    {
                        Connection con=null;
                        con=Util.openConnection(con);
                         String codPersonal=request.getParameter("codPersonal");
                         String codDocumento=request.getParameter("codDoc");
                         String codCuestionario=request.getParameter("codC");
                         String consulta=" select d.NOMBRE_DOCUMENTO,d.CODIGO_DOCUMENTO,"+
                                     " tdb.NOMBRE_TIPO_DOCUMENTO_BIBLIOTECA,tdbi.NOMBRE_TIPO_DOCUMENTO_BPM_ISO,"+
                                     " ae.NOMBRE_AREA_EMPRESA,isnull(m.NOMBRE_MAQUINA, '') as NOMBRE_MAQUINA,"+
                                     " ISNULL(m.CODIGO, '') as CODIGO,versionDoc.NRO_VERSION,"+
                                     " (p.AP_PATERNO_PERSONAL + ' ' + p.AP_MATERNO_PERSONAL + ' ' +"+
                                     "   p.NOMBRES_PERSONAL + ' ' + p.nombre2_personal) as nombrePersonal,"+
                                     "   ed.NOMBRE_ESTADO_DOCUMENTO,"+
                                     "   versionDoc.URL_DOCUMENTO from DOCUMENTACION d"+
                                    " inner join TIPOS_DOCUMENTO_BIBLIOTECA tdb on"+
                                     "  d.COD_TIPO_DOCUMENTO_BIBLIOTECA = tdb.COD_TIPO_DOCUMENTO_BIBLIOTECA"+
                                     "  inner join TIPOS_DOCUMENTO_BPM_ISO tdbi on tdbi.COD_TIPO_DOCUMENTO_BPM_ISO"+
                                     "  = d.COD_TIPO_DOCUMENTO_BPM_ISO"+
                                     "  inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA = d.COD_AREA_EMPRESA"+
                                     "  left outer join maquinarias m on m.COD_MAQUINA = d.COD_MAQUINA"+
                                     "  cross APPLY"+
                                     " ("+
                                     "   select top 1 vd.NRO_VERSION,"+
                                     "   vd.COD_PERSONAL_ELABORA,"+
                                     "          vd.COD_ESTADO_DOCUMENTO,"+
                                     "          vd.URL_DOCUMENTO"+
                                     "   from VERSION_DOCUMENTACION vd"+
                                     "   where vd.COD_DOCUMENTO = d.COD_DOCUMENTO"+
                                     "   order by vd.NRO_VERSION desc"+
                                     " ) versionDoc"+
                                     " inner join personal p on p.COD_PERSONAL = versionDoc.COD_PERSONAL_ELABORA"+
                                     " inner join ESTADOS_DOCUMENTO ed on ed.COD_ESTADO_DOCUMENTO ="+
                                     " versionDoc.COD_ESTADO_DOCUMENTO"+
                                     " where d.COD_DOCUMENTO='"+codDocumento+"'";
                                    System.out.println("consulta cabecera "+consulta);
                                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                    ResultSet res=st.executeQuery(consulta);
                                    if(res.next())
                                    {
                                        %>
                                          <table cellpadding="0" cellspacing="0" style="border:1px solid black">
                                                <tr>
                                                    <td  align="center" style="border-bottom: 1px solid black" colspan="4" class="headerC outputText2" >Datos Documento</td>
                                                </tr>
                                                
                                                <tr>
                                                   
                                                    <td style="padding:3px;"><span style="font-weight:bold;" class="outputText2">Nombre Doc</span></td>
                                                    <td style="padding:3px;"><span style="font-weight:bold;" class="outputText2">::</span></td>
                                                    <td style="padding:3px;"><span class="outputText2"><%=res.getString("NOMBRE_DOCUMENTO")%></span></td>
                                                </tr>
                                                <tr>
                                                    <td style="padding:3px;"><span style="font-weight:bold;" class="outputText2">Codigo</span></td>
                                                    <td style="padding:3px;"><span style="font-weight:bold;" class="outputText2">::</span></td>
                                                    <td style="padding:3px;"><span class="outputText2"><%=res.getString("CODIGO_DOCUMENTO")%></span></td>
                                                </tr>
                                                <tr>
                                                    <td style="padding:3px;"><span style="font-weight:bold;" class="outputText2">Tipo Documento</span></td>
                                                    <td style="padding:3px;"><span style="font-weight:bold;" class="outputText2">::</span></td>
                                                    <td style="padding:3px;"><span class="outputText2"><%=res.getString("NOMBRE_TIPO_DOCUMENTO_BIBLIOTECA")%></span></td>
                                                </tr>
                                                <tr>
                                                    <td style="padding:3px;"><span style="font-weight:bold;" class="outputText2">Nivel Doc:</span></td>
                                                    <td style="padding:3px;"><span style="font-weight:bold;" class="outputText2">::</span></td>
                                                    <td style="padding:3px;"><span class="outputText2"><%=res.getString("NOMBRE_AREA_EMPRESA")%></span></td>
                                                </tr>
                                                <tr>
                                                    <td style="padding:3px;"><span style="font-weight:bold;" class="outputText2">Maquina</span></td>
                                                    <td style="padding:3px;"><span style="font-weight:bold;" class="outputText2">::</span></td>
                                                    <td style="padding:3px;"><span class="outputText2"><%=(res.getString("NOMBRE_MAQUINA").equals("")?"":(res.getString("NOMBRE_MAQUINA")+"("+res.getString("CODIGO")+")"))%></span></td>
                                                </tr>
                                                 <tr>
                                                    <td style="padding:3px;"><span style="font-weight:bold;" class="outputText2">Elaborado por</span></td>
                                                    <td style="padding:3px;"><span style="font-weight:bold;" class="outputText2">::</span></td>
                                                    <td style="padding:3px;"><span class="outputText2"><%=res.getString("nombrePersonal")%></span></td>
                                                </tr>
                                          </table>
                                          <input type="hidden" value="<%=codCuestionario%>" id="codCuestionario"/>
                                          <input type="hidden" value="<%=codPersonal%>" id="codPersonal"/>
                                        <%
                                    }
                            %>
                            <table style="margin-top:9px;">
                                <tr>
                                    <td class="outputText2">
                                        Correctas
                                    </td>
                                    <td style="width:50px" class="correcta">

                                    </td>
                               
                                    <td class="outputText2">
                                        Incorrectas
                                    </td>
                                    <td style="width:50px" class="incorrecta">

                                    </td>
                                </tr>
                            </table>
                        <table cellpadding="0" id="cuestionario" cellspacing="0" style="border:1px solid black;margin-top:12px;">
                                <tr>
                                    <td  align="center" style="border-bottom: 1px solid black" colspan="2" class="headerC outputText2" >Cuestionario</td>
                                    <td  align="center" style="border-bottom: 1px solid black" colspan="2" class="headerC outputText2" >Puntaje</td>
                                    <td align="center" style="border-bottom: 1px solid black;border-left:1px solid black;" class="headerC outputText2"> Puntaje</td>
                                </tr>
                  
                            <%
                              
                                 
                                    consulta="select dp.COD_PREGUNTA,dp.DESCRIPCION_PREGUNTA,dr.COD_RESPUESTA,dr.DESCRIPCION_RESPUESTA" +
                                            ",dp.PREGUNTA_CERRADA,cpd.RESPUESTA_CERRADA,cpd.RESPUESTA_ABIERTA,dr.RESPUESTA" +
                                             ",ISNULL(cr.CALIFICACION,0) as CALIFICACION"+
                                             " from CUESTIONARIO_PERSONAL_DETALLE cpd inner join DOCUMENTACION_PREGUNTAS dp"+
                                             " on dp.COD_PREGUNTA=cpd.COD_PREGUNTA "+
                                             " left outer join DOCUMENTACION_RESPUESTAS dr on"+
                                             " dp.COD_DOCUMENTO=dr.COD_DOCUMENTO and dp.COD_PREGUNTA=dr.COD_PREGUNTA"+
                                             " and dr.COD_RESPUESTA=cpd.COD_RESPUESTA" +
                                             " left outer join CALIFICACION_RESPUESTAS_CUESTIONARIO_PERSONAL cr on "+
                                             " cr.COD_PREGUNTA=dp.COD_PREGUNTA and cpd.COD_CUESTIONARIO=cr.COD_CUESTIONARIO"+
                                             " where cpd.COD_CUESTIONARIO='"+codCuestionario+"' and dp.COD_DOCUMENTO='"+codDocumento+"'"+
                                             " order by cpd.COD_PREGUNTA";
                                    System.out.println("consulta pregunta "+consulta);
                                    res=st.executeQuery(consulta);
                                    boolean preguntaCerrada=false;
                                    boolean sinrepuesta=false;
                                    boolean respuesta=false;
                                    int cont=0;
                                    int codCabecera=0;
                                    NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                                    DecimalFormat format = (DecimalFormat)nf;
                                    format.applyPattern("###0.##");

                                    while(res.next())
                                    {
                                        respuesta=res.getInt("RESPUESTA")>0;
                                        if(codCabecera!=res.getInt("COD_PREGUNTA"))
                                        {
                                            out.println((preguntaCerrada&&!sinrepuesta)?"</table></td> </tr>":"");
                                            codCabecera=res.getInt("COD_PREGUNTA");
                                            cont++;
                                            out.println("<tr><td class='preguntaCell'><span class='outputText2 pregunta'>"+cont+"</span></td> " +
                                                    "<td class='preguntaCell'><input type='hidden' value='"+res.getString("COD_PREGUNTA")+"'><span class='outputText2 pregunta'>"+res.getString("DESCRIPCION_PREGUNTA")+"</span><br/></td>" +
                                                    "<td rowspan='2' class='celdaRespuesta' valign='top'><input class='inputText' type='text' size='6' value='"+nf.format(res.getDouble("CALIFICACION"))+"'/></td></tr>");
                                            out.println("<tr><td></td>");
                                            preguntaCerrada=res.getInt("PREGUNTA_CERRADA")>0;
                                            sinrepuesta=res.getInt("RESPUESTA_CERRADA")==3;
                                            out.println(preguntaCerrada?(sinrepuesta?"<td class='outputText2'>No se cargaron Respuestas</td></tr>":
                                                "<td><table cellpadding='0' cellspacing='0' ><tr><td class='"+((respuesta==(res.getInt("RESPUESTA_CERRADA")>0))?"correcta":"incorrecta")+"'><input type='checkbox' disabled "+(res.getInt("RESPUESTA_CERRADA")>0?"checked":"")+"></td><td class='outputText2 respuesta "+((respuesta==(res.getInt("RESPUESTA_CERRADA")>0))?"correcta":"incorrecta")+"'><input type='hidden' value='"+res.getString("COD_RESPUESTA")+"'/>"+res.getString("DESCRIPCION_RESPUESTA")+"</td></tr>"):
                                                "<td class='outputText2 respuesta'><span>"+res.getString("RESPUESTA_ABIERTA")+"</span></td></tr>");
                                        }
                                        else
                                        {
                                            out.println("<tr><td class='"+((respuesta==(res.getInt("RESPUESTA_CERRADA")>0))?"correcta":"incorrecta")+"' ><input type='checkbox' disabled "+(res.getInt("RESPUESTA_CERRADA")>0?"checked":"")+"></td><td class='outputText2 respuesta "+((respuesta==(res.getInt("RESPUESTA_CERRADA")>0))?"correcta":"incorrecta")+"'><input type='hidden' value='"+res.getString("COD_RESPUESTA")+"'/>"+res.getString("DESCRIPCION_RESPUESTA")+"</td></tr>");
                                        }
                                    }
                                    out.println((preguntaCerrada&&!sinrepuesta)?"</table></td> </tr>":"");
                                    /*while(res.next())
                                    {
                                        out.println("<tr><td><input type='checkbox'></td><td class='outputText2 respuesta'><input type='hidden' value='"+res.getString("COD_RESPUESTA")+"'/>"+res.getString("DESCRIPCION_RESPUESTA")+"</td></tr>");
                                    }
                                    out.println((preguntaCerrada&&!sinrepuesta)?"</table></td> </tr>":"");*/
                        res.close();
                        st.close();
                        con.close();
                    }
                    catch(SQLException ex)
                    {
                        ex.printStackTrace();
                    }
                    %>
                    
            </table>
                  <table>
                      <tr>

                       <td colspan="2" align="center">
                           <button class="buttonGuardar" onclick="guardarCalificacion();" >Guardar</button>
                        <button class="buttonGuardar" onclick="window.close();">Cancelar</button>
                       </td>
                    </tr>
                  </table>
            </div>
        </form>
        <script type="text/javascript" language="JavaScript"  src="../../js/dlcalendar.js" ></script>
    </body>
</html>