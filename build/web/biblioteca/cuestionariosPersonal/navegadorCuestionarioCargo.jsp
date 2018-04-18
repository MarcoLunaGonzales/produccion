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
                window.onbeforeunload=permitir;
                function permitir()
                {
                   return 'Esta seguro de salir,el cuestionario se guardara automaticamente?';
                }
                var minutos=0;
                window.onunload=guardarResultados;
                var myVar=setInterval(function(){myTimer()},60000);
                function myTimer()
                {
                   minutos++;
                   document.getElementById("minutos").innerHTML=minutos+" min.";
                }

           </script>
    </head>
    <body style="border:none;" ><br><br>
        <h3 align="center"></h3>
            
        <form onsubmit="return false;" name="upform" method="post" action="agregarDocumentacionBiblioteca.jsf" enctype="multipart/form-data">
            <div align="center">

                    <%
                    try
                    {
                     
                        Connection con=null;
                        con=Util.openConnection(con);
                         String codCuestionario=request.getParameter("codCuestionario");
                         String codPersonal=request.getParameter("codPersonal");
                         String consulta="select cc.NOMBRE_CUESTIONARIO,cc.TIEMPO_CUESTIONARIO,cc.NRO_PREGUNTAS_ARGUMENTO"+
                                         " from cuestionarios_cargo cc where cc.COD_CUESTIONARIO_CARGO='"+codCuestionario+"'";
                         System.out.println("consulta cargar Datos "+consulta);
                         Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                         ResultSet res=st.executeQuery(consulta);
                         int nroPreguntas=0;
                         String nombreCuestionario="";
                         float tiempoCuestionario=0;
                         if(res.next())
                         {
                             nombreCuestionario=res.getString("NOMBRE_CUESTIONARIO");
                             nroPreguntas=res.getInt("NRO_PREGUNTAS_ARGUMENTO");
                             tiempoCuestionario=res.getInt("TIEMPO_CUESTIONARIO");
                         }
                         consulta="select dap.cod_argumento"+
                                  " from DOCUMENTACION_ARGUMENTOS_PRODUCTO dap"+
                                  "  where dap.cod_presentacion in (select c.COD_PRESENTACION from CUESTIONARIOS_CARGO_PRESENTACIONES_PRODUCTO c where c.COD_CUESTIONARIO_CARGO='"+codCuestionario+"')";
                        System.out.println("consulta aleatorio "+consulta);
                        List<String> codArray=new ArrayList<String>();
                        res=st.executeQuery(consulta);
                        while(res.next())
                        {
                            codArray.add(res.getString("cod_argumento"));
                        }
                        System.out.println(nroPreguntas);
                        if(codArray.size()<Integer.valueOf(nroPreguntas))
                        {

                            con.close();
                            out.println("<script>alert('No se han cargado las suficientes preguntas para el cuestionario');window.location.href='navegadorDocumentosPersonal.jsf';</script>");
                        }
                        else
                        {
                           
                                        %>
                                          <table cellpadding="0" cellspacing="0" style="border:1px solid black">
                                                <tr>
                                                    <td  align="center" style="border-bottom: 1px solid black" colspan="4" class="headerC outputText2" >Datos Cuestionario</td>
                                                </tr>
                                                <tr>

                                                    <td style="padding:3px;"><span style="font-weight:bold;" class="outputText2">NOMBRE</span></td>
                                                    <td style="padding:3px;"><span style="font-weight:bold;" class="outputText2">::</span></td>
                                                    <td style="padding:3px;"><span class="outputText2"><%=(nombreCuestionario)%></span></td>
                                                 </tr>
                                                <tr>
                                                    <td style="padding:3px;"><span style="font-weight:bold;" class="outputText2">Tiempo para Examén</span></td>
                                                    <td style="padding:3px;"><span style="font-weight:bold;" class="outputText2">::</span></td>
                                                    <td style="padding:3px;"><span class="outputText2"><%=(tiempoCuestionario)%> min.</span></td>
                                                </tr>
                                                <tr>
                                                    <td style="padding:3px;"><span style="font-weight:bold;" class="outputText2">Minutos Transcurridos</span></td>
                                                    <td style="padding:3px;"><span style="font-weight:bold;" class="outputText2">::</span></td>
                                                    <td style="padding:3px;"><span  id="minutos" class="outputText2">0 min.</span></td>
                                                </tr>
                                                
                                          </table>
                                          <input type="hidden" value="<%=(codCuestionario)%>" id="codDocumento"/>
                                          <input type="hidden" value="<%=codPersonal%>" id="codPersonal"/>
                              
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
                                    consulta="select dap.descripcion_pregunta"+
                                             " from DOCUMENTACION_ARGUMENTOS_PRODUCTO dap"+
                                             " where dap.cod_argumento='"+codPregunta+"'";
                                    System.out.println("consulta pregunta "+consulta);
                                    res=st.executeQuery(consulta);
                                    boolean preguntaCerrada=false;
                                    boolean sinrepuesta=false;
                                    while(res.next())
                                    {
                                        out.println("<tr><td class='preguntaCell'><span class='outputText2 pregunta'>"+cont+"</span></td> " +
                                                "<td class='preguntaCell'><input type='hidden' value='"+codPregunta+"'><span class='outputText2 pregunta'>"+res.getString("descripcion_pregunta")+"</span><br/></td></tr>");
                                        out.println("<tr><td></td><td class='outputText2 respuesta'><textarea rows='3' cols='60'></textarea></td></tr>");
                                    }
                                    
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