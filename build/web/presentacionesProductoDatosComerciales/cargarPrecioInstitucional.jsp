<html>
    <%@ page  import="javazoom.upload.*,java.util.*,java.io.*" %>
    
    <%@ page  import="jxl.*" %>
    <%@ page  import="jxl.Sheet" %>
    <%@ page  import="jxl.Workbook" %>
    <%@ page  import="jxl.read.biff.BiffException" %>
    <%@ page  import="com.cofar.util.*" %>
    <%@ page  import="java.sql.*" %>
    
    <jsp:useBean id="upBean" scope="page" class="javazoom.upload.UploadBean" >
        <jsp:setProperty name="upBean" property="folderstore" />
    </jsp:useBean>
    
    <%
    boolean mostrar=false;
    Connection connection=null;
    connection=Util.openConnection(connection);
    
    
    if (MultipartFormDataRequest.isMultipartFormData(request)) {
        MultipartFormDataRequest mrequest = new MultipartFormDataRequest(request);
        System.out.println(request);
        
        String todo = null;
        if (mrequest != null) todo = mrequest.getParameter("todo");
        if ( (todo != null) && (todo.equalsIgnoreCase("upload")) ) {
            Hashtable files = mrequest.getFiles();
            if ( (files != null) && (!files.isEmpty()) ) {
                UploadFile file = (UploadFile) files.get("uploadfile");
                
                try{
                    mostrar=true;
                    upBean.store(mrequest, "uploadfile");
                    Workbook xls=Workbook.getWorkbook(file.getInpuStream());
                    Sheet sheet=xls.getSheet(0);
                    int rows=sheet.getRows();
                    for(int i=2;i<rows;i++){
                        Cell celdaCodPresentacion=sheet.getCell(0,i);
                        Cell celdaNombreProducto=sheet.getCell(1,i);
                        Cell celpreciominimo=sheet.getCell(2,i);
                        Cell celdacodareaempresa=sheet.getCell(3,i);
                        
                        
                        String CODPRESENTACION=celdaCodPresentacion.getContents();
                        String NOMBREPRESENTACION=celdaNombreProducto.getContents();
                        String PRECIOMINIMO=celpreciominimo.getContents();
                        String CODAREAEMPRESA=celdacodareaempresa.getContents();
                        
    /*String stockmin="0";
    if(!celdaStockMin.getType().equals(CellType.FORMULA_ERROR)){
    stockmin=celdaStockMin.getContents();
    }
     */
                        
                        CODPRESENTACION=(CODPRESENTACION==null)?"":CODPRESENTACION;
                        
                        System.out.println("CODPRESENTACION :"+CODPRESENTACION);
                        System.out.println("NOMBREPRESENTACION :"+NOMBREPRESENTACION);
                        System.out.println("PRECIOMINIMO :"+PRECIOMINIMO);
                        System.out.println("CODAREAEMPRESA :"+CODAREAEMPRESA);
                        /*System.out.println("AAAAAAAAAA:"+celdaStockMin.getType());*/
    /*if(!cod_presentacion.equals("")){
 
 
    String sql="select count(*) from PRESENTACIONES_PRODUCTO_DATOSCOMERCIALES where cod_presentacion="+cod_presentacion+"and cod_area_empresa="+cod_area_empresa;
 
    PreparedStatement st2=connection.prepareStatement(sql);
    ResultSet rs2=st2.executeQuery();
    int count=0;
    if(rs2.next())
    count=rs2.getInt(1);
 
    if(count==0){
    sql="insert into PRESENTACIONES_PRODUCTO_DATOSCOMERCIALES(cod_presentacion,cod_area_empresa,STOCK_MINIMO)values(";
    sql+=""+cod_presentacion+",";
    sql+=""+cod_area_empresa+",";
    sql+=""+stockmin+")";
    }else{
    sql="update PRESENTACIONES_PRODUCTO_DATOSCOMERCIALES set stock_minimo="+stockmin;
    sql+=" where cod_area_empresa="+cod_area_empresa;
    sql+=" and cod_presentacion="+cod_presentacion;
    System.out.println("SQL:"+sql);
 
    }
 
 
 
 
 
 
    PreparedStatement st=connection.prepareStatement(sql);
    int resultado=st.executeUpdate();
 
    }*/
                    }
                    xls.close();
                    
                    
    /*   out.println("<li>Form field : uploadfile"+"<BR> Uploaded file" +
    " : "+file.getFileName()+" ("+file.getFileSize()+" bytes)"+"<BR> Content Type : "+file.getContentType());
     */
                    
                }catch(BiffException  bf){
                    out.println("<li>AAAAAAAAAA");
                }
                
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
            if( !confirm('Esta seguro de cargar los precios institucionales') ){
                return false;   
            }
            
            
        }
        </script>
    </head>
    <body bgcolor="#FFFFFF" text="#000000">
        
        <form method="post" action="registrarPrecioInstitucional.jsf" name="upform" enctype="multipart/form-data">
            <div align="center">
                
                <%
                if(!mostrar){%>
                
                
                
                <table border="0" class="outputText2" style="border:1px solid #000000" cellspacing="0" cellpadding="0" width="50%">    
                    <tr class="headerClassACliente">
                        <td  colspan="3" >
                            <div class="outputText2" align="center">
                                Cargar Precios Institucionales
                            </div>    
                        </td>                        
                    </tr>
                    <tr >
                        <td>&nbsp;</td>
                        <td  >
                            <input type="file"  id="uploadfile" name="uploadfile" class="inputText"  value="Cargar Archivo" size="70" >
                        </td>                        
                        <td>&nbsp;</td>
                    </tr>
                    <tr >
                        <td  colspan="3" >
                            <div class="outputText2" align="center">
                                <input type="submit" class="commandButton" value="Registrar" onclick="return validar();">
                                <input type="hidden" name="todo" value="upload">
                            </div>    
                        </td>                        
                    </tr>
                </table>
                <br/>
                <%}%>
                
                
                <%
                if(mostrar){%>
                <table border="0" class="outputText2" style="border:1px solid #000000" cellspacing="0" cellpadding="5">    
                    <%
                    String sql="select (select NOMBRE_AREA_EMPRESA from AREAS_EMPRESA a where a.cod_area_empresa=pd.cod_area_empresa)  as NOMBRE_AREA_EMPRESA,";
                    sql+="(select NOMBRE_PRODUCTO_PRESENTACION from  PRESENTACIONES_PRODUCTO p where p.cod_presentacion = pd.cod_presentacion),stock_minimo,cod_area_empresa ";
                    sql+=" from PRESENTACIONES_PRODUCTO_DATOSCOMERCIALES pd where pd.cod_estado_registro=1 order by NOMBRE_AREA_EMPRESA asc";
                    
                    System.out.println(sql);
                    Statement st=connection.createStatement();
                    ResultSet rs=st.executeQuery(sql);
                    int codigo=0;
                    while(rs.next()){
                        String nombreareaempresa=rs.getString(1);
                        String nombreproducto=rs.getString(2);
                        int stockminimo=rs.getInt(3);
                        int cod_area_empresa=rs.getInt(4);
                        if(codigo!=cod_area_empresa ){codigo=cod_area_empresa;%>
                    <tr class="headerClassACliente">
                        <td  colspan="2" align="CENTER">
                            <%=nombreareaempresa%>
                        </td>                        
                    </tr>
                    <tr class="headerClassACliente">
                        <td   align="CENTER">
                            Presentacion
                        </td>
                        <td   align="CENTER">
                            Stock Minimo
                        </td>
                        
                    </tr>
                    
                    <%}
                    %>
                    <tr>
                        
                        <td style="border-right:#000000 solid 1px"><%=nombreproducto%></td>
                        <td ><%=stockminimo%></td>
                        
                        
                    </tr>
                    <%}%>
                </table>
                <center>
                    <input type="button" class="commandButton" size="35" value="Atras"  onclick="javascript:history.back(1)">                
                    
                </center>
                
                
                
                <%   rs.close();st.close();connection.close();}      %>
                
            </div>
        </form>
    </body>
    
</html>
