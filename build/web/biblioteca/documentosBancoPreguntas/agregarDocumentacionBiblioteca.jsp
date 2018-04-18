package biblioteca.documentosBiblioteca_1;

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
<%@ page  import="javazoom.upload.*,java.util.*,java.io.*" %>
<%@ page  import="jxl.*" %>
<%@ page  import="jxl.Sheet" %>
<%@ page  import="jxl.Workbook" %>
<%@ page import="java.text.*" %>
<%
    String direccion = request.getSession().getServletContext().getRealPath("biblioteca/documentosBiblioteca/documentosBiblioteca/");
%>
<jsp:useBean id="upBean" scope="page" class="javazoom.upload.UploadBean" >
        <jsp:setProperty name="upBean" property="folderstore" />
        <jsp:setProperty name="upBean" property="folderstore" value="<%=direccion%>" />
    <jsp:setProperty name="upBean" property="whitelist" value="*.jpg,*.gif,*.pdf" />
    <jsp:setProperty name="upBean" property="overwritepolicy" value="nametimestamp"/>
    </jsp:useBean>

<%
String codProd=request.getParameter("codProd");

if (MultipartFormDataRequest.isMultipartFormData(request)) {
 MultipartFormDataRequest mrequest = new MultipartFormDataRequest(request);
 String todo = null;
 if (mrequest != null) {
  todo = mrequest.getParameter("todo");
 }

 if ((todo != null) && (todo.equalsIgnoreCase("upload"))) {
  Hashtable files = mrequest.getFiles();
  if ((files != null) && (!files.isEmpty())) {
     
   java.text.SimpleDateFormat formato = new java.text.SimpleDateFormat("yyMMddHHmmss");
   String archivo = ((UploadFile) mrequest.getFiles().get("uploadfile")).getFileName();
   int posicionPunto = archivo.indexOf(".");
   String nombreImagen = archivo.substring(0, posicionPunto);
   String extension = archivo.substring(posicionPunto);
   codProd=mrequest.getParameter("codComprod");
   System.out.println("ext "+extension);
   if(extension.toLowerCase().equals(".pdf"))
       {
           nombreImagen = nombreImagen ;//+ formato.format(new java.util.Date())
           
           SimpleDateFormat sdf =new SimpleDateFormat("yyyy-MM-dd-HH-mm");
           String codDocumento="";
           try{

               Connection con=null;
               con=Util.openConnection(con);
               String consulta="select ISNULL(MAX(d.COD_DOCUMENTO),0)+1 as codDoc from DOCUMENTACION d ";
               Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
               ResultSet res=st.executeQuery(consulta);
               if(res.next())
               {
                   codDocumento=res.getString("codDoc");
               }
               String[] fechaCargado=mrequest.getParameter("fechaCargado").split("/");
               String[] fechaElaboracion=mrequest.getParameter("fechaElaboracion").split("/");
               String[] fechaIngresoV=mrequest.getParameter("fechaIngresoVigencia").split("/");
               String[] fechaRevision=mrequest.getParameter("fechaRevision").split("/");
               nombreImagen = nombreImagen +"-cd-"+codDocumento+"-f-"+sdf.format(new Date())+ extension;
               consulta="INSERT INTO DOCUMENTACION(COD_DOCUMENTO, NOMBRE_DOCUMENTO, CODIGO_DOCUMENTO,"+
                        " COD_TIPO_DOCUMENTO_BIBLIOTECA, COD_TIPO_DOCUMENTO_BPM_ISO, COD_AREA_EMPRESA,COD_MAQUINA)"+
                        " VALUES ('"+codDocumento+"','"+mrequest.getParameter("nombreDocumento")+"','"+mrequest.getParameter("codigoDocumento")+"',"+
                        " '"+mrequest.getParameter("codTipoDoc")+"','"+mrequest.getParameter("codTipoDocBpmISo")+"','"+mrequest.getParameter("codNivel")+"',"+
                        " '"+mrequest.getParameter("codmaquina")+"')";
               System.out.println("consulta cargar documento "+consulta);
               PreparedStatement pst=con.prepareStatement(consulta);
               if(pst.executeUpdate()>0)System.out.println("se registro la cebecera doc");
               consulta="INSERT INTO VERSION_DOCUMENTACION(COD_DOCUMENTO, NRO_VERSION, FECHA_CARGADO,"+
                        " FECHA_ELABORACION, FECHA_INGRESO_VIGENCIA, FECHA_PROXIMA_REVISION,"+
                        " COD_PERSONAL_ELABORA, COD_ESTADO_DOCUMENTO, URL_DOCUMENTO)"+
                        " VALUES ('"+codDocumento+"',1,'"+fechaCargado[2]+"/"+fechaCargado[1]+"/"+fechaCargado[0]+" 12:00:00'," +
                        " '"+fechaElaboracion[2]+"/"+fechaElaboracion[1]+"/"+fechaElaboracion[0]+" 12:00:00',"+
                        " '"+fechaIngresoV[2]+"/"+fechaIngresoV[1]+"/"+fechaIngresoV[0]+" 12:00:00'," +
                        " '"+fechaRevision[2]+"/"+fechaRevision[1]+"/"+fechaRevision[0]+" 12:00:00', '"+mrequest.getParameter("codElaborado")+"',"+
                        " '"+mrequest.getParameter("codEstado")+"','"+nombreImagen+"')";
               System.out.println("consulta insert detalle "+consulta);
               pst=con.prepareStatement(consulta);
               if(pst.executeUpdate()>0)System.out.println("se registro la primera version");
               pst.close();
               con.close();
            }
            catch(SQLException ex)
            {
                ex.printStackTrace();
            }
           
           ((UploadFile) mrequest.getFiles().get("uploadfile")).setFileName(nombreImagen);
           UploadFile file = (UploadFile) files.get("uploadfile");
           if (file != null)
           {
            out.println("<script>alert('El archivo se subio correctamente');var a=Math.random();window.location.href='navegadorDocumentosBiblioteca.jsf?a='+a</script>");
           }
            upBean.store(mrequest, "uploadfile");
           }
           else
           {
            out.println("<script>alert('Solo puede subir archivos pdf');</script>");
           }
          }
   
  else {
    out.println("Archivos no subidos");
  }
 } else {
   out.println("<BR> todo=" + todo);
 }
}

%>
<html >
    <head>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script src="../../js/general.js"></script>
        
    </head>
    <body style="border:none;" ><br><br>
        <h3 align="center"></h3>
            <script type="text/javascript">
                function validarRegistro(formulario,archivo)
                {
                    if(valFecha(document.getElementById("fechaCargado"))&&valFecha(document.getElementById("fechaElaboracion"))
                        &&valFecha(document.getElementById("fechaIngresoVigencia"))&&valFecha(document.getElementById("fechaRevision")))
                        {
                            if(document.getElementById("nombreDocumento").value=='')
                                {
                                    alert('Debe registrar el nombre del documento');
                                    return false;
                                }
                                if(document.getElementById("codigoDocumento").value=='')
                                {
                                    alert('Debe registrar el codigo del documento');
                                    return false;
                                }
                           if(!archivo)
                               {
                                   alert('No se ha seleccionado ningun archivo');
                                   return false;
                               }
                               else
                                   {
                                       var extension= (archivo.substring(archivo.lastIndexOf("."))).toLowerCase();
                                       
                                       if(extension!=".pdf")
                                           {
                                                alert('Solo puede seleccionar archivos pdf');
                                                return false;
                                           }
                                   }


                                return true;
                        }

                            return false;
                }

            </script>
        <form name="upform" method="post" action="agregarDocumentacionBiblioteca.jsf" enctype="multipart/form-data">
            <div align="center">
                            <h3 >Agregar Documento Biblioteca</h3>
                        
        <table style="border-top:1px solid black;width:85%;border-left:1px solid black;margin-top:12px" cellpadding="0" cellspacing="0">
            
            <tr bgcolor="#9d5a9e" style="color:white;font-weight:bold;" > <td style="font-weight:bold;border-bottom:1px solid black;border-right:1px solid black;padding:4px" align="center" colspan="6" class="outputText2" >Adicionar Documentos</td></tr>
            <tr>
                <td colspan="3" style="font-weight:bold;border-bottom:1px solid black;border-right:1px solid black;">&nbsp;</td>
            </tr>
            <tr bgcolor="#9d5a9e" style="color:white;font-weight:bold;" >
            <td colspan="2" style="font-weight:bold;border-bottom:1px solid black;border-right:1px solid black;padding:4px;" class="outputText2">Nombre Documento</td>
            <td colspan="1" style="font-weight:bold;border-bottom:1px solid black;border-right:1px solid black;padding:4px;" class="outputText2">Codigo</td>
            </tr>
            <tr bgcolor="" style="color:white;font-weight:bold;" >
            <td colspan="2" style="font-weight:bold;border-bottom:1px solid black;border-right:1px solid black;padding:4px;" align="center">
                <input value="" type="text" id="nombreDocumento" name="nombreDocumento" style="width:95%" class="inputText"> </td>
            <td colspan="1" style="font-weight:bold;border-bottom:1px solid black;border-right:1px solid black;padding:4px;" >
                <input value="" type="text" id="codigoDocumento" name="codigoDocumento" style="width:95%" class="inputText">
            </td>
            </tr>

            <tr bgcolor="#9d5a9e" style="color:white;font-weight:bold;" >
            <td colspan="1" style="font-weight:bold;border-bottom:1px solid black;border-right:1px solid black;padding:4px;" class="outputText2">Tipo Documento</td>
            <td colspan="1" style="font-weight:bold;border-bottom:1px solid black;border-right:1px solid black;padding:4px;" class="outputText2">Doc. BPM-ISO</td>
            <td colspan="1" style="font-weight:bold;border-bottom:1px solid black;border-right:1px solid black;padding:4px;" class="outputText2">Fecha Cargado</td>
            </tr>
            <tr bgcolor="" style="color:white;font-weight:bold;" >
            <td colspan="" style="font-weight:bold;border-bottom:1px solid black;border-right:1px solid black;padding:4px;" align="center">
            <select id="codTipoDoc" name="codTipoDoc" class="inputText">
            <%
            try
            {
                Connection con1=null;
                con1=Util.openConnection(con1);
                SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
                Date fechaDefecto=new Date();
                Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                String consulta="select tdb.COD_TIPO_DOCUMENTO_BIBLIOTECA,tdb.NOMBRE_TIPO_DOCUMENTO_BIBLIOTECA"+
                                " from TIPOS_DOCUMENTO_BIBLIOTECA tdb where tdb.COD_ESTADO_REGISTRO=1 " +
                                " order by tdb.NOMBRE_TIPO_DOCUMENTO_BIBLIOTECA";
                ResultSet res=st.executeQuery(consulta);
                while(res.next())
                    {
                    %>
                        <option value="<%=res.getString("COD_TIPO_DOCUMENTO_BIBLIOTECA")%>"> <%=res.getString("NOMBRE_TIPO_DOCUMENTO_BIBLIOTECA")%></option>
                    <%
                    }
                %>
                        </select>
                    </td>
                    <td colspan="" style="font-weight:bold;border-bottom:1px solid black;border-right:1px solid black;padding:4px;" align="center">
                    <select id="codTipoDocBpmISo" name="codTipoDocBpmISo" class="inputText">
                     <%
                     consulta="select tdb.COD_TIPO_DOCUMENTO_BPM_ISO,tdb.NOMBRE_TIPO_DOCUMENTP_BPM_ISO"+
                              " from TIPOS_DOCUMENTO_BPM_ISO tdb where tdb.COD_ESTADO_REGISTRO=1 order  by tdb.NOMBRE_TIPO_DOCUMENTP_BPM_ISO";
                     res=st.executeQuery(consulta);
                     while(res.next())
                     {
                         out.println("<option value='"+res.getString("COD_TIPO_DOCUMENTO_BPM_ISO")+"'> "+res.getString("NOMBRE_TIPO_DOCUMENTP_BPM_ISO")+"</option>");
                     }
                     %>
                    </select>
                        <td colspan="1" style="font-weight:bold;border-bottom:1px solid black;border-right:1px solid black;padding:4px;" align="center">
                            <input value="<%=sdf.format(fechaDefecto)%>" type="text" id="fechaCargado" name="fechaCargado" size="10" class="inputText"/>
                            <img id="imagenFecha1" src="../../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7;
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fechaCargado" click_element_id="imagenFecha1">
                             </DLCALENDAR>
                        </td>
                    </tr>
                     <tr bgcolor="#9d5a9e" style="color:white;font-weight:bold;" >
                            <td colspan="1" style="font-weight:bold;border-bottom:1px solid black;border-right:1px solid black;padding:4px;" class="outputText2">Fecha Elaboración</td>
                            <td colspan="1" style="font-weight:bold;border-bottom:1px solid black;border-right:1px solid black;padding:4px;" class="outputText2">Fecha Ingreso Vigencia</td>
                            <td colspan="1" style="font-weight:bold;border-bottom:1px solid black;border-right:1px solid black;padding:4px;" class="outputText2">Fecha Próxima Revisión</td>
                    </tr>
                    <tr>
                         <td colspan="1" style="font-weight:bold;border-bottom:1px solid black;border-right:1px solid black;padding:4px;" align="center">
                            <input value="<%=sdf.format(fechaDefecto)%>" type="text" id="fechaElaboracion" name="fechaElaboracion" size="10" class="inputText"/>
                            <img id="imgelaboracion" src="../../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7;
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fechaElaboracion" click_element_id="imgelaboracion">
                             </DLCALENDAR>
                        </td>
                         <td colspan="1" style="font-weight:bold;border-bottom:1px solid black;border-right:1px solid black;padding:4px;" align="center">
                            <input value="<%=sdf.format(fechaDefecto)%>" type="text" id="fechaIngresoVigencia" name="fechaIngresoVigencia" size="10" class="inputText"/>
                            <img id="imgIngreso" src="../../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7;
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fechaIngresoVigencia" click_element_id="imgIngreso">
                             </DLCALENDAR>
                        </td>
                         <td colspan="1" style="font-weight:bold;border-bottom:1px solid black;border-right:1px solid black;padding:4px;" align="center">
                            <input value="<%=sdf.format(fechaDefecto)%>" type="text" id="fechaRevision" name="fechaRevision" size="10" class="inputText"/>
                            <img id="imgRevision" src="../../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7;
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fechaRevision" click_element_id="imgRevision">
                             </DLCALENDAR>
                        </td>
                    </tr>
                    <tr bgcolor="#9d5a9e" style="color:white;font-weight:bold;" >
                            <td colspan="1" style="font-weight:bold;border-bottom:1px solid black;border-right:1px solid black;padding:4px;" class="outputText2">Número de Revisión</td>
                            <td colspan="2" style="font-weight:bold;border-bottom:1px solid black;border-right:1px solid black;padding:4px;" class="outputText2">Elaborado por:</td>
                    </tr>
                    <tr>
                        <td colspan="1" style="font-weight:bold;border-bottom:1px solid black;border-right:1px solid black;padding:4px;" align="center">
                            <span class="outputText2">1</span>
                            
                        </td>
                        <td colspan="2" style="font-weight:bold;border-bottom:1px solid black;border-right:1px solid black;padding:4px;" align="center">
                            <select id="codElaborado" name="codElaborado">
                                <%
                                 consulta="select p.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+ ' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal) as nombrePersona"+
                                          " from PERSONAL p where p.COD_ESTADO_PERSONA=1"+
                                          " order by p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL";
                                 res=st.executeQuery(consulta);
                                 while(res.next())
                                 {
                                     out.println("<option value='"+res.getString("COD_PERSONAL")+"'> "+res.getString("nombrePersona")+"</option>");
                                 }
                                 %>
                            </select>
                        </td>
                    </tr>
                     <tr bgcolor="#9d5a9e" style="color:white;font-weight:bold;" >
                            <td colspan="1" style="font-weight:bold;border-bottom:1px solid black;border-right:1px solid black;padding:4px;" class="outputText2">Estado</td>
                            <td colspan="1" style="font-weight:bold;border-bottom:1px solid black;border-right:1px solid black;padding:4px;" class="outputText2">Nivel Organizacional</td>
                            <td colspan="1" style="font-weight:bold;border-bottom:1px solid black;border-right:1px solid black;padding:4px;" class="outputText2">Maquinaria</td>
                    </tr>
                    <tr>
                        <td colspan="1" style="font-weight:bold;border-bottom:1px solid black;border-right:1px solid black;padding:4px;" align="center">
                         <select id="codEstado" name="codEstado">
                                <%
                                 consulta="select ed.COD_ESTADO_DOCUMENTO,ed.NOMBRE_ESTADO_DOCUMENTO from ESTADOS_DOCUMENTO ed where ed.COD_ESTADO_REGISTRO=1 order by ed.NOMBRE_ESTADO_DOCUMENTO";
                                 res=st.executeQuery(consulta);
                                 while(res.next())
                                 {
                                     out.println("<option value='"+res.getString("COD_ESTADO_DOCUMENTO")+"'> "+res.getString("NOMBRE_ESTADO_DOCUMENTO")+"</option>");
                                 }
                                 %>
                            </select>
                        </td>
                        <td colspan="1" style="font-weight:bold;border-bottom:1px solid black;border-right:1px solid black;padding:4px;" align="center">
                         <select id="codNivel" name="codNivel">
                                <%
                                 consulta="select ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA from AREAS_EMPRESA ae where ae.COD_ESTADO_REGISTRO=1 order by ae.NOMBRE_AREA_EMPRESA";
                                 res=st.executeQuery(consulta);
                                 while(res.next())
                                 {
                                     out.println("<option value='"+res.getString("COD_AREA_EMPRESA")+"'> "+res.getString("NOMBRE_AREA_EMPRESA")+"</option>");
                                 }
                                 %>
                            </select>
                        </td>
                        <td colspan="1" style="font-weight:bold;border-bottom:1px solid black;border-right:1px solid black;padding:4px;" align="center">
                         <select id="codmaquina" name="codmaquina">
                                <%
                                         consulta="select m.COD_MAQUINA,(m.NOMBRE_MAQUINA+'('+m.CODIGO+')') as nombreMaquina from MAQUINARIAS m where m.COD_ESTADO_REGISTRO=1 order by m.NOMBRE_MAQUINA";
                                         res=st.executeQuery(consulta);
                                         out.println("<option value='0'> -Ninguno-</option>");
                                         while(res.next())
                                         {
                                             out.println("<option value='"+res.getString("COD_MAQUINA")+"'> "+res.getString("nombreMaquina")+"</option>");
                                         }
                                 %>
                            </select>
                        </td>
                    </tr>
                    <tr bgcolor="#9d5a9e" style="color:white;font-weight:bold;" >
                            <td colspan="3" style="font-weight:bold;border-bottom:1px solid black;border-right:1px solid black;padding:4px;" class="outputText2">Documento</td>
                    </tr>
                    <tr>
                         <td colspan="3" style="font-weight:bold;border-bottom:1px solid black;border-right:1px solid black;padding:4px;" align="center">
                            <input type="file" name="uploadfile" id="uploadfile" accept=".pdf" style="width:90%" />
                        </td>
                    </tr>
                    
                <%
                res.close();
                st.close();
                con1.close();
            }
            catch(SQLException ex)
            {
                ex.printStackTrace();
            }
            %>
            
        </table>
      
              
              <div style="margin-top:4px">
              <input type="hidden" name="todo" value="upload">
              <input type="submit" value="Guardar" class="btn" onclick="if(validarRegistro(this.form,this.form.uploadfile.value)==false){return false;}">
              <button class="btn"  onclick="var a=Math.random();window.location.href='navegadorDocumentosBiblioteca.jsf?a='+a">Cancelar</button>
              </div>
            </div>
            <input type="hidden" value="<%=codProd%>" name="codComprod" id="codComprod"/>
            
        </form>
        <script type="text/javascript" language="JavaScript"  src="../../js/dlcalendar.js" ></script>
    </body>
</html>