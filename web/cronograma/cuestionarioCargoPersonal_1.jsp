package cronograma;


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
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../js/general.js"></script>
        <script src="../js/json.js"></script>
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
                function respuesta(codRespuesta)
                {
                    this.codRespuesta=codRespuesta;
                    this.seleccionado=0;
                }
                function pregunta(codDocumento,codPregunta,preguntaCerrada)
                {
                    this.codDocumento=codDocumento;
					this.respuestaAbierta='';
					this.preguntaCerrada=preguntaCerrada;
                    this.codPregunta=codPregunta;
                    this.respuestas=[];
                    this.addRespuesta=function(respuesta1)
                    {
                        this.respuestas[this.respuestas.length]=respuesta1;
                    }
                }
                function respuestaArgumento(codArgumento)
                {
                    this.codArgumento=codArgumento;
                    this.textoRespuesta='';
                }

                function cuestionario(codPersonal,codCuestionarioCargo)
                {
                    this.codPersonal=codPersonal;
                    this.codCuestionarioCargo=codCuestionarioCargo;
                    this.tiempoRegistro=0;
                    this.preguntas=[];
                    this.respuestasArgumentos=[];
                    this.addPregunta=function(pregunta)
                    {
                        this.preguntas[this.preguntas.length]=pregunta;
                    }
                    this.addRespuestaArgumento=function(respuestaArg)
                    {
                         this.respuestasArgumentos[this.respuestasArgumentos.length]=respuestaArg;
                    }
                }
                function guardarResultados()
                {
                    var tabla=document.getElementById("cuestionario");
                    var cuestionarioRegistro=new cuestionario(1,2);
                    
                        ajax=nuevoAjax();
                        
                        ajax.open("POST","ajaxGuardarCuestionarioRevisado_1.jsf",true);
                       // ajax.setRequestHeader(header, value)
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
                                    alert('Se registraron las respuestas');
                                    window.location.href='navegadorCuestionariosCargoPersonal.jsf';
                                    
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
                        
                        ajax.send(JSON.stringify(cuestionarioRegistro));
                        //ajax.send(null);
                        

                        
                }
                var puedeEvaluar=true;
                function permitir()
                {
                    if(puedeEvaluar)
                        {
                            return 'Esta seguro de salir,el cuestionario se guardara automaticamente?';
                        }
                }
                
                var minutos=0;
                var tiempoExamen=0;
            //    window.onunload=guardarResultados;
                var myVar=setInterval(function(){myTimer()},60000);//60000
                function myTimer()
                {
                   minutos++;
                   if((tiempoExamen*0.1)>=(tiempoExamen-minutos))
                   {
                       document.getElementById("minutos").style.backgroundColor='red';
                   }
                   document.getElementById("minutos").innerHTML=minutos+" min.";
                }
               
           </script>
    </head>
    <body style="border:none;" >
        <h3 align="center"></h3>
            
        <form onsubmit="return false;" name="upform" method="post" action="agregarDocumentacionBiblioteca.jsf" enctype="multipart/form-data">
            <div align="center">

                    
                    <tr>
                       <td colspan="2" align="center">
                             <button class="btn" onclick="guardarResultados();">Guardar</button>
                             <button class="btn" onclick="window.location.href='navegadorCuestionariosCargoPersonal.jsf'">Cancelar</button>
                       </td>
                    </tr>
            </table>
                  
            </div>
        </form>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js" ></script>
    </body>
</html>