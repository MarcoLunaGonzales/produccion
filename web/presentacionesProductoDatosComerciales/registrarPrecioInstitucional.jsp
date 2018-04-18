<html>
    <%@ page  import="javazoom.upload.*,java.util.*,java.io.*" %>
    
    <%@ page  import="jxl.*" %>
    <%@ page  import="jxl.Sheet" %>
    <%@ page  import="jxl.Workbook" %>
    <%@ page  import="jxl.read.biff.BiffException" %>
    <%@ page  import="com.cofar.util.*" %>
    <%@ page  import="java.sql.*" %>
    <%@ page import="java.text.*" %>
    <%@ page  import="java.util.Date" %>
    
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
                    for(int i=1;i<rows;i++){
                        Cell celdaCodPresentacion=sheet.getCell(0,i);
                        Cell celdaNombreProducto=sheet.getCell(1,i);
                        Cell celprecioinstitucional=sheet.getCell(2,i);
                        Cell celdacodareaempresa=sheet.getCell(3,i);
                        
                        
                        String CODPRESENTACION=celdaCodPresentacion.getContents();
                        String NOMBREPRESENTACION=celdaNombreProducto.getContents();
                        String PRECIOINSTITUCIONAL=celprecioinstitucional.getContents();
                        String CODAREAEMPRESA=celdacodareaempresa.getContents();
                        
    /*String stockmin="0";
    if(!celdaStockMin.getType().equals(CellType.FORMULA_ERROR)){
    stockmin=celdaStockMin.getContents();
    }
     */
                        
                        CODPRESENTACION=(CODPRESENTACION==null)?"":CODPRESENTACION;
                        
                        System.out.println("CODPRESENTACION :"+CODPRESENTACION);
                        System.out.println("NOMBREPRESENTACION :"+NOMBREPRESENTACION);
                        String PRECIOINSTITUCIONALAUX=PRECIOINSTITUCIONAL.replace(",",".");
                        System.out.println("PRECIOINSTITUCIONAL :"+PRECIOINSTITUCIONAL);
                        System.out.println("PRECIOINSTITUCIONALAUX :"+PRECIOINSTITUCIONALAUX);
                        System.out.println("CODAREAEMPRESA :"+CODAREAEMPRESA);
                        /*System.out.println("AAAAAAAAAA:"+celdaStockMin.getType());*/
                        if(!CODPRESENTACION.equals("")){
                            SimpleDateFormat f=new SimpleDateFormat("yyyy/MM/dd");
                            Date date=new Date();
                            String fechaHoy=f.format(date);
                            String sql="select count(*) from PRESENTACIONES_PRODUCTO_DATOSCOMERCIALES where cod_presentacion="+CODPRESENTACION+"and cod_area_empresa="+CODAREAEMPRESA;
                            PreparedStatement st2=connection.prepareStatement(sql);
                            ResultSet rs2=st2.executeQuery();
                            int count=0;
                            if(rs2.next())
                                count=rs2.getInt(1);
                            if(count==0){
                                sql="insert into PRESENTACIONES_PRODUCTO_DATOSCOMERCIALES(cod_presentacion,cod_area_empresa,PRECIO_INSTITUCIONAL,FECHA_REGISTRO,COD_ESTADO_REGISTRO)values(";
                                sql+=""+CODPRESENTACION+",";
                                sql+=""+CODAREAEMPRESA+",";
                                sql+=""+PRECIOINSTITUCIONALAUX+",";
                                sql+="'"+fechaHoy+"',1)";
                            }else{
                                System.out.println("ACTUALIZAAAAAAAAAAAAAAAAAAAAAA");
                                sql="update PRESENTACIONES_PRODUCTO_DATOSCOMERCIALES set PRECIO_INSTITUCIONAL="+PRECIOINSTITUCIONALAUX;
                                sql+=" where cod_area_empresa="+CODAREAEMPRESA+" and cod_presentacion="+CODPRESENTACION+" and cod_estado_registro=1";
                                System.out.println("SQL:"+sql);
                            }
                            PreparedStatement st=connection.prepareStatement(sql);
                            int resultado=st.executeUpdate();
                            System.out.println("resultado123333333333333333333"+resultado);                            
                        }
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
            if( !confirm('Esta seguro de actualizar los precios minimos') ){
                return false;   
            }
        }
        </script>
    </head>
    <body bgcolor="#FFFFFF" text="#000000">
        
        <form method="post" action="registrarstockmin.jsf" name="upform" enctype="multipart/form-data">
            <div align="center">
                
                <%
                if(!mostrar){%>
                <table border="0" class="outputText2" style="border:1px solid #000000" cellspacing="0" cellpadding="0" width="50%">    
                    <tr class="headerClassACliente">
                        <td  colspan="3" >
                            <div class="outputText2" align="center">
                                Cargar Precios Minimos
                            </div>    
                        </td>                        
                    </tr>
                    <tr >
                        <td  >
                            <input type="file"       id="uploadfile" name="uploadfile" class="inputText"  value="Cargar Archivo" size="100">
                        </td>                        
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
                    NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                    DecimalFormat form = (DecimalFormat)nf;
                    form.applyPattern("#,###.00");
                    String sql10="select (select NOMBRE_AREA_EMPRESA from AREAS_EMPRESA a where a.cod_area_empresa=pd.cod_area_empresa)  as NOMBRE_AREA_EMPRESA,";
                    sql10+="(select NOMBRE_PRODUCTO_PRESENTACION from  PRESENTACIONES_PRODUCTO p where p.cod_presentacion = pd.cod_presentacion) as nombrePresentacion,PRECIO_INSTITUCIONAL,cod_area_empresa ";
                    sql10+=" from PRESENTACIONES_PRODUCTO_DATOSCOMERCIALES pd where pd.cod_estado_registro=1 order by NOMBRE_AREA_EMPRESA,nombrePresentacion asc";                    
                    System.out.println(sql10);
                    Statement st10=connection.createStatement();
                    ResultSet rs10=st10.executeQuery(sql10);
                    int codigo=0;
                    while(rs10.next()){
                        String nombreareaempresa=rs10.getString(1);
                        String nombreproducto=rs10.getString(2);
                        float precio_institucional=rs10.getFloat(3);
                        int cod_area_empresa=rs10.getInt(4);
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
                            Precio Institucional
                        </td>
                        
                    </tr>
                    
                    <%}
                    %>
                    <tr>
                        
                        <td style="border-right:#000000 solid 1px"><%=nombreproducto%></td>
                        <td align="right" ><%=form.format(precio_institucional)%></td>
                        
                        
                    </tr>
                    <%}%>
                </table>
                <center>
                    <input type="button" class="commandButton" size="35" value="Atras"  onclick="javascript:history.back(1)">                
                    
                </center>
                
                
                
                <%   rs10.close();st10.close();connection.close();}      %>
                
            </div>
        </form>
    </body>
    
</html>
