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
    String direccion = request.getSession().getServletContext().getRealPath("controlMarcasProducto/certificadosPdf/");
%>
<jsp:useBean id="upBean" scope="page" class="javazoom.upload.UploadBean" >
        <jsp:setProperty name="upBean" property="folderstore" />
        <jsp:setProperty name="upBean" property="folderstore" value="<%=direccion%>" />
    <jsp:setProperty name="upBean" property="whitelist" value="*.jpg,*.gif,*.pdf" />
    <jsp:setProperty name="upBean" property="overwritepolicy" value="nametimestamp"/>
    </jsp:useBean>

<%
String codMarcaProducto=request.getParameter("codMarcaProducto");

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
   String archivo = new String(((UploadFile) mrequest.getFiles().get("uploadfile")).getFileName().getBytes("ISO-8859-1"),"UTF-8");
   int posicionPunto =archivo.lastIndexOf(".");
   String nombreImagen = archivo.substring(0, posicionPunto);
   String extension = archivo.substring(posicionPunto);
   codMarcaProducto=mrequest.getParameter("codComprod");
   System.out.println("ext "+extension);
   if(extension.toLowerCase().equals(".pdf"))
       {
           nombreImagen = nombreImagen ;//+ formato.format(new java.util.Date())
           
           SimpleDateFormat sdf =new SimpleDateFormat("yyyy-MM-dd-HH-mm");
           nombreImagen = nombreImagen +"-cm-"+codMarcaProducto+"-f-"+sdf.format(new Date())+ extension;
           ((UploadFile) mrequest.getFiles().get("uploadfile")).setFileName(nombreImagen);
           UploadFile file = (UploadFile) files.get("uploadfile");
           if (file != null)
           {
            try{

               Connection con=null;
               con=Util.openConnection(con);
               System.out.println("codMarca "+codMarcaProducto);
               String consulta="update MARCAS_PRODUCTO set URL_RESOLUCION_RENOVACION=?"+
                               " where cod_marca_producto=?";
               //System.out.println("consulta update "+consulta);
               PreparedStatement pst=con.prepareStatement(consulta);
               pst.setString(1,file.getFileName());
               pst.setInt(2,Integer.valueOf(codMarcaProducto));
               if(pst.executeUpdate()>0)System.out.println("se registraron los datos para la marca");
               out.println("<script>alert('El archivo se subio correctamente');parent.ocultaRegistro();parent.refrescar();</script>");
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
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../js/general.js"></script>
        
    </head>
    <body style="border:none;" bgcolor="#eeeeee"><br><br>
        <h3 align="center"></h3>
<script type="text/javascript">
    function validarRegistro(formulario,archivo)
    {
        if(valFecha(document.getElementById("fecha_inicio")))
            {
                if(document.getElementById("resolucionRenovacion").value=='')
                    {
                        alert('Debe registrar la resolucion de renovación');
                        return false;
                    }
               if(!archivo)
                   {
                       alert('No se ha seleccionado ningun archivo');
                       return false;
                   }
                   else
                       {
                           
                           var extension=(archivo.split("."));
                           console.log(extension[extension.length-1].toLowerCase());
                           if(extension[extension.length-1].toLowerCase()!="pdf")
                               {
                                    alert('Solo puede seleccionar archivos pdf');
                                    return false;
                               }
                       }

                    document.getElementById("productoparaRenovacion").value=
                        (document.getElementById("productoRenovacion").checked?"1":"0"
                    );
                    return true;
            }
            
                return false;
    }

</script>
        <form name="upform" method="post" action="subirArchivoPdf.jsf" enctype="multipart/form-data">
            <div align="center" style="border:solid black 1px;width:95%;">
        <table style=" width:100%;">
            <%
            Connection con=null;
            SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
            try
             {
                con=Util.openConnection(con);
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                String consulta="select mp.NOMBRE_MARCA_PRODUCTO,emp.NOMBRE_ESTADO_MARCA_PRODUCTO,"+
                                " mp.RESOLUCION_RENOVACION,mp.FECHA_REGISTRO_MARCA"+
                                " from MARCAS_PRODUCTO mp inner join ESTADOS_MARCA_PRODUCTO emp on "+
                                " mp.COD_ESTADO_MARCA_PRODUCTO=emp.COD_ESTADO_MARCA_PRODUCTO "+
                                " where mp.COD_MARCA_PRODUCTO='"+codMarcaProducto+"'";
                System.out.println("consulta prod "+consulta);
                ResultSet res=st.executeQuery(consulta);
                
                if(res.next())
                    {
            %>
            <tr class="headerClassACliente"> <td style="font-weight:bold !important" align="center" colspan="6" class="outputText2" >
                DATOS DE LA MARCA</td></tr>
            <tr>
            <td style="font-weight:bold" class="outputText2">Nombre Marca</td>
            <td style="font-weight:bold" class="outputText2">::</td>
            <td  class="outputText2"><%=res.getString("NOMBRE_MARCA_PRODUCTO")%></td>
            <td style="font-weight:bold" class="outputText2">Estado Marca</td>
            <td style="font-weight:bold" class="outputText2">::</td>
            <td  class="outputText2"><%=res.getString("NOMBRE_ESTADO_MARCA_PRODUCTO")%></td>
            </tr>
            <tr>
            <td style="font-weight:bold" class="outputText2">Resolución de Renovación</td>
            <td style="font-weight:bold" class="outputText2">::</td>
            <td  class="outputText2"><%=(res.getString("RESOLUCION_RENOVACION"))%></td>
            
            <td style="font-weight:bold" class="outputText2">Fecha Registro Marca</td>
            <td style="font-weight:bold" class="outputText2">::</td>
            <td class="outputText2"><%=(sdf.format(res.getDate("FECHA_REGISTRO_MARCA")))%></td>
            
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
                <table style="width:100%;margin-top:1em">
                 <tr class='dr-table-subheader rich-table-subheader'>
                          <td colspan="2" class="outputText2 dr-table-subheadercell rich-table-subheadercell headerClassACliente" style="font-size:12;font-weight:bold" >
                              <center>Seleccionar Archivo Certificado</center>
                          </td>
                          
                      </tr>
                      <tr>
                          <td class="outputText2" style="font-weight:bold">Archivo:</td>
                          <td ><input type="file" name="uploadfile" id="uploadfile" accept=".spdf" style="width:40em" /> </td>
                      </tr>
                  
              </table>
              <input type="hidden" id="productoparaRenovacion" name="productoparaRenovacion" value="0"/>
             
              <div style="margin-top:4px">
              <input type="hidden" name="todo" value="upload">
              <input type="submit" value="Guardar" onclick="if(validarRegistro(this.form,this.form.uploadfile.value)==false){return false;}">
              <button  onclick="parent.ocultaRegistro();">Cancelar</button>
              </div>
            </div>
            <input type="hidden" value="<%=codMarcaProducto%>" name="codComprod" id="codComprod"/>
            
        </form>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js" ></script>
    </body>
</html>