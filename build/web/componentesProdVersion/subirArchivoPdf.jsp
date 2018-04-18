<%@page contentType="text/html"%>
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
   
    String direccion = request.getSession().getServletContext().getRealPath("componentesProdVersion/certificadosPdf/");
%>
<jsp:useBean id="upBean" scope="page" class="javazoom.upload.UploadBean" >
    <jsp:setProperty name="upBean" property="folderstore" value="<%=direccion%>" />
    <jsp:setProperty name="upBean" property="whitelist" value="*.pdf" />
    <jsp:setProperty name="upBean" property="overwritepolicy" value="nametimestamp"/>
</jsp:useBean>

<%

String codVersion=request.getParameter("codVersion");
if (MultipartFormDataRequest.isMultipartFormData(request)) 
{
 MultipartFormDataRequest mrequest = new MultipartFormDataRequest(request);
 String todo = null;
 if (mrequest != null) {
  todo = mrequest.getParameter("todo");
 }

 if ((todo != null) && (todo.equalsIgnoreCase("upload"))) {
    Hashtable files = mrequest.getFiles();
    if ((files != null) && (!files.isEmpty())) {
        java.text.SimpleDateFormat formato = new java.text.SimpleDateFormat("yyMMddHHmmss");
        String archivo = new String(((UploadFile) mrequest.getFiles().get("uploadfile")).getFileName().getBytes("ISO-8859-1"),"UTF-8");
        int posicionPunto =archivo.lastIndexOf(".");
        String nombreImagen = archivo.substring(0, posicionPunto);
        String extension = archivo.substring(posicionPunto);
        codVersion=mrequest.getParameter("codComprod");
        if(extension.toLowerCase().equals(".pdf"))
        {
            nombreImagen = nombreImagen ;//+ formato.format(new java.util.Date())

            SimpleDateFormat sdf =new SimpleDateFormat("yyyy-MM-dd-HH-mm");
            nombreImagen = "certificadoProducto" +"-cm-"+codVersion+"-f-"+sdf.format(new Date())+ extension;
            ((UploadFile) mrequest.getFiles().get("uploadfile")).setFileName(nombreImagen);

            UploadFile file = (UploadFile) files.get("uploadfile");
            if (file != null)
            {
                try{

                    Connection con=null;
                    con=Util.openConnection(con);
                    String consulta="update COMPONENTES_PROD_VERSION set DIRECCION_ARCHIVO_REGISTRO_SANITARIO=?,CERTIFICADO_REGISTRO_SANITARIO=? where COD_VERSION='"+codVersion+"'";
                    System.out.println("consulta update "+consulta+" "+file.getFileName());
                    PreparedStatement pst=con.prepareStatement(consulta);
                    pst.setString(1,file.getFileName());
                    pst.setBytes(2,file.getData());
                    if(pst.executeUpdate()>0)System.out.println("se subio el registro sanitario");
                    out.println("<script>alert('El archivo se subio correctamente');parent.refrescar();parent.ocultaRegistro();</script>");
                    pst.close();
                    con.close();
                }
                catch(SQLException ex)
                {
                    out.println("<script>alert('Ocurrio un error al momento de subir el archivo, intente de nuevo');</script>");
                    ex.printStackTrace();
                }
                catch(Exception e)
                {
                    out.println("<script>alert('Ocurrio un error al momento de subir el archivo, intente de nuevo');</script>");
                    e.printStackTrace();
                }
            }
        }
        else
        {
         out.println("<script>alert('Solo puede subir archivos pdf');</script>");
        }
    }
   
  else 
  {
    out.println("Archivos no subidos");
  }
 } else {
   out.println("<BR> todo=" + todo);
 }
}

%>
<html >
    <head>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../js/general.js"></script>
        
    </head>
    <body style="border:none;" bgcolor="#eeeeee">
        <script type="text/javascript">
            function validarRegistro(formulario,archivo)
            {
                document.getElementById("botones").style.display="none";
                       if(!archivo)
                           {
                               alert('No se ha seleccionado ningun archivo');
                               document.getElementById("botones").style.display="";
                               return false;
                           }
                           else
                               {

                                   var extension=(archivo.split("."));
                                   console.log(extension[extension.length-1].toLowerCase());
                                   if(extension[extension.length-1].toLowerCase()!="pdf")
                                       {
                                            alert('Solo puede seleccionar archivos pdf');
                                            document.getElementById("botones").style.display="";
                                            return false;
                                       }
                               }

                            return true;

            }

        </script>
        <form name="upform" method="post" action="subirArchivoPdf.jsp" enctype="multipart/form-data">
            <center>
                <table style=" width:100%;background-color: white;" class="tablaFiltroReporte" cellpading="0" cellspacing="0">
                    <%
                    Connection con=null;
                    SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
                    try
                     {
                        con=Util.openConnection(con);
                        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        String consulta="select isnull(c.nombre_prod_semiterminado,'') as nombre_prod_semiterminado,c.REG_SANITARIO,c.VIDA_UTIL,c.FECHA_VENCIMIENTO_RS" +
                                        " from COMPONENTES_PROD_VERSION c where c.COD_VERSION='"+codVersion+"'";
                        System.out.println("consulta prod "+consulta);
                        ResultSet res=st.executeQuery(consulta);
                        if(res.next())
                            {
                    %>
                    <tr class="headerClassACliente"> <td style="font-weight:bold !important" align="center" colspan="6" class="outputText2" >
                        DATOS DEL PRODUCTO</td></tr>
                    <tr>
                    <td style="font-weight:bold" class="outputText2">Nombre Producto</td>
                    <td style="font-weight:bold" class="outputText2">::</td>
                    <td  class="outputText2"><%=res.getString("nombre_prod_semiterminado")%></td>
                    <td style="font-weight:bold" class="outputText2">Registro Sanitario</td>
                    <td style="font-weight:bold" class="outputText2">::</td>
                    <td  class="outputText2"><%=res.getString("REG_SANITARIO")%></td>
                    </tr>
                    <tr>
                    <td style="font-weight:bold" class="outputText2">Vida Util</td>
                    <td style="font-weight:bold" class="outputText2">::</td>
                    <td  class="outputText2"><%=(res.getString("VIDA_UTIL")+" meses")%></td>

                    <td style="font-weight:bold" class="outputText2">Fecha Vencimiento R.S.</td>
                    <td style="font-weight:bold" class="outputText2">::</td>
                    <td class="outputText2"><%=(sdf.format(res.getDate("FECHA_VENCIMIENTO_RS")))%></td>

                    </tr>

                    </table>
            <%
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
            <table style="width:100%;margin-top:1em;background-color: white;" class="tablaFiltroReporte"
                   cellpading="0" cellspacing="0">
                 <tr class='dr-table-subheader rich-table-subheader'>
                          <td colspan="2" class="outputText2 dr-table-subheadercell rich-table-subheadercell headerClassACliente" style="font-size:12;font-weight:bold" >
                              <center>Seleccionar Archivo Certificado</center>
                          </td>
                          
                      </tr>
                      <tr>
                          <td class="outputText2" style="font-weight:bold">Archivo:</td>
                          <td ><input type="file" name="uploadfile" id="uploadfile" accept=".pdf" style="width:40em" /> </td>
                      </tr>
                  
            </table>
              <input type="hidden" id="productoparaRenovacion" name="productoparaRenovacion" value="0"/>
             
              <div style="margin-top:4px" id="botones">
              <input type="hidden" name="todo" value="upload">
              <input type="submit" value="Guardar" class="btn" onclick="if(validarRegistro(this.form,this.form.uploadfile.value)==false){return false;}">
              <a class="btn"  onclick="parent.ocultaRegistro();">Cancelar</a>
              </div>
            </center>
            <input type="hidden" value="<%=(codVersion)%>" name="codComprod" id="codComprod"/>
            
        </form>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js" ></script>
    </body>
</html>