<%@ page  import="jxl.*" %>
<%@ page  import="jxl.Sheet" %>
<%@ page  import="jxl.Workbook" %>
<%@ page  import="jxl.read.biff.BiffException" %>
<%@ page  import="java.sql.*" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.util.*" %>
<%@ page import="javazoom.upload.*" %>
<%@ page import="com.cofar.util.*" %>

<html>

<%
try{
Connection con=null;
con=Util.openConnection(con);
String path= application.getRealPath("");
String realpathX=path+"\\biblioteca";
System.out.println(realpathX);
%>

<jsp:useBean id="upBean" scope="page" class="javazoom.upload.UploadBean" >
    <jsp:setProperty name="upBean" property="folderstore"  value="<%=realpathX%>"  />
</jsp:useBean>

<%
String mensaje = "";
if (MultipartFormDataRequest.isMultipartFormData(request)) {
    MultipartFormDataRequest mrequest = new MultipartFormDataRequest(request);
    System.out.println(request);



    String todo = null;
    if (mrequest != null) todo = mrequest.getParameter("todo");
    if ( (todo != null) && (todo.equalsIgnoreCase("upload")) ) {
        Hashtable files = mrequest.getFiles();
        if ( (files != null) && (!files.isEmpty()) ) {
            UploadFile file = (UploadFile) files.get("uploadfile");

            upBean.store(mrequest, "uploadfile");
            String codEntidadFinanciera = mrequest.getParameter("codEntidadFinanciera")!=null? mrequest.getParameter("codEntidadFinanciera"):"";
            System.out.println("codEntidadFinanciera " + codEntidadFinanciera );
            String fechaIngresoDeposito = mrequest.getParameter("fechaIngresoDeposito")!=null? mrequest.getParameter("fechaIngresoDeposito"):"";
            System.out.println("fechaIngresoDeposito " + fechaIngresoDeposito);
            String codDocumentacion = mrequest.getParameter("codDocumentacion")!=null? mrequest.getParameter("codDocumentacion"):"";
            System.out.println("codDocumentacion " + codDocumentacion);

            String codAreaEmpresa=mrequest.getParameter("codAreaEmpresa");
            String  realpathY=realpathX+"\\"+file.getFileName();
            //proceso de cargado en la tabla
            System.out.println("el path:" + realpathY);
            Transactions t = new Transactions();
            t.cargarDatosDeposito(con, file.getInpuStream(), codEntidadFinanciera, fechaIngresoDeposito,codDocumentacion);

            //GenerarActualizacion g = new GenerarActualizacion();



            //mensaje = g.cargarDatosDeposito(con,file.getInpuStream(),codEntidadFinanciera,fechaIngresoDeposito);

            out.println("<li>"+mensaje);

        } else {
            out.println("<li>El archivo no se cargo correctamente");
        }
    }
}
%>



<head>
    <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
    <script>
        function validar(){
            var uploadfile=document.getElementById('uploadfile');
            if(uploadfile.value==''){
                alert('Por favor escoga el archivo para cargar');
                uploadfile.focus();
                return false;
            }
            var texto=uploadfile.value;
            texto=texto.substring(   texto.length-4    ,texto.length   );

            if(texto!='.xls'){
                  alert('El Archivo que escogio no esta en el formato excel');
                  return false;
            }
            if( !confirm('Esta seguro de actualizar los stocks minimos') ){
                return false;
            }

        }
    </script>
</head>
<body bgcolor="#FFFFFF" text="#000000" onload="window.location='subirArchivoPdf.jsf?mensaje=<%=mensaje%>'">

<form method="post" action="registrarstockmin.jsf" name="upform" enctype="multipart/form-data">
    <div align="center">

    YA FINALIZO EL PROCESO DE ACTUALIZACION<br/>


    </div>
</form>

</body>
<%
}catch(Exception e){
    e.printStackTrace();
}

%>


</html>
