<%@ page import = "java.util.Properties" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.text.DecimalFormat"%> 
<%@ page import = "java.text.NumberFormat"%> 
<%@ page import = "java.util.Locale"%> 
<%@ page import = "java.util.*"%> 
<%@ page import = "java.text.*"%> 
<%@ page import = "java.text.DecimalFormat"%> 
<%@ page import = "java.text.NumberFormat"%> 
<%@ page import = "java.util.Locale"%> 
<%@ page import = "java.lang.Math"%> 
<%@ page import = "java.text.SimpleDateFormat"%> 
            


<%!Connection con = null;   
%> 


<html>
<head>
    <title>REPORTE  DE  VERIFICACION  BACO  -  ATLAS (Fórmulas Maestras)</title>
    <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
    <script src="../../js/general.js"></script>
</head>
<body>
    <div align="center">
    <table width="100%" >
        <tr >
            <td colspan="3" align="center" >
                <h4>Reporte Formula Maestra</h4>
            </td>
        </tr>
        <tr>
            <td align="left"><img src= "../img/cofar.png"></td> 
        </tr>
    </table>
    
    
    <table width="90%" align="center" class="outputText0" style="border : solid #000000 1px;" cellpadding="0" cellspacing="0" >
       <tr>

            <td align="center" class="outputTextBlanco"  bgcolor="#000000">Lote</td>
            <td align="center" class="outputTextBlanco"  bgcolor="#000000">Producto</td>
            <td colspan="4" align="center"><b>BACO</b></td>
            <td colspan="2" align="center"><b>ATLAS</b></td>              
            <td colspan="2" align="center"><b>DIFERENCIA</b></td>
        </tr>  
        <tr>
            <td align="center" class="outputTextBlanco"  bgcolor="#000000">&nbsp;</td>
            <td align="center" class="outputTextBlanco"  bgcolor="#000000">&nbsp;</td>
            <td colspan="4"><b>&nbsp;</b></td>
            <td colspan="2"><b>&nbsp;</b></td> 
            <td colspan="2"><b>&nbsp;</b></td>
        </tr>
        <tr>
            
           <td align="center" class="outputTextBlanco"  bgcolor="#000000">&nbsp;</td>
           <td align="center" class="outputTextBlanco"  bgcolor="#000000">&nbsp;</td>
            <td align="center" class="outputTextBlanco"  bgcolor="#000000">Unid</td>
            <td align="center" class="outputTextBlanco"  bgcolor="#000000">Salidas</td>
            <td align="center" class="outputTextBlanco"  bgcolor="#000000">Devoluc.</td>
            <td align="center" class="outputTextBlanco"  bgcolor="#000000">Neta</td>
            <td align="center" class="outputTextBlanco"  bgcolor="#000000">Unid</td>
            <td align="center" class="outputTextBlanco"  bgcolor="#000000">Cant.</td>
            <td align="center" class="outputTextBlanco"  bgcolor="#000000">Cant.</td>
            <td align="center" class="outputTextBlanco"  bgcolor="#000000"> % </td>
        </tr>             
        
        <%  
        /*SACO LOS DATOS DE LA BASE DE DATOS BACO*/
        int rowcount = 0;
        
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat form = (DecimalFormat)nf;
        form.applyPattern("#,###.00");
        
        con = Util.openConnection(con);
        String codigosPrograma=request.getParameter("codigosPrograma");
        String fecha_inicio=request.getParameter("fecha_inicio");
        String fecha_fin=request.getParameter("fecha_fin");
        String PORCENTAJE_VARIACION  = request.getParameter("PorcentajeVariacion");
        
        SimpleDateFormat df=new SimpleDateFormat("MM/dd/yyyy");        
        String D_Inicio = df.format(Util.converterStringDate(request.getParameter("fecha_inicio")));
        String D_Salida = df.format(Util.converterStringDate(request.getParameter("fecha_fin")));
        
        System.out.println("FECHA_INICIO-----> " + D_Inicio );
        System.out.println("FECHA_FIN--------> " + D_Salida );

        String sql = "";
        sql  = " select distinct s.COD_LOTE_PRODUCCION,(select c.nombre_prod_semiterminado from COMPONENTES_PROD c where c.COD_COMPPROD=s.COD_PROD),s.FECHA_SALIDA_ALMACEN from  SALIDAS_ALMACEN s where ";              
        sql += " s.COD_PROD in("+codigosPrograma+") and s.FECHA_SALIDA_ALMACEN between '"+ D_Inicio +"' and '"+ D_Salida +"' ";
        

        
        System.out.println("sql ---> " + sql);
        System.out.println("fecha Inicial--->" + fecha_inicio);
        System.out.println("fecha FINAL--->" + fecha_fin);
        
        Statement stmt = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rs = stmt.executeQuery(sql);
        SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");
        while (rs.next()){
            //String codsalidaalmacen= rs.getString(1);
            String COD_LOTE_PRODUCCION= rs.getString(1);
            String nombre_prod_semiterminado= rs.getString(2);
            java.util.Date FECHASAL =  rs.getDate(3);
        %>
        <tr>
            <td class=colh align="center" style="border : solid #f2f2f2 1px;"><b><%=COD_LOTE_PRODUCCION%> </b>   </td>
            <td class=colh align="center" style="border : solid #f2f2f2 1px;"><b><%=nombre_prod_semiterminado%>  </b> </td>
        </tr>
        <%
        %>
        <tr>
            <td class=colh align="center" style="border : solid #f2f2f2 1px;"><b>MATERIA PRIMA </b>   </td>            
        </tr>
        <%
        //Saco el nombre del producto
        String sqla = "";
        sqla  = " select (select m.NOMBRE_MATERIAL from MATERIALES m where m.COD_MATERIAL = sd.COD_MATERIAL) as NOMBRE, ";
        sqla += " sd.COD_MATERIAL , ";
        sqla += " (select u.ABREVIATURA from UNIDADES_MEDIDA u where u.COD_UNIDAD_MEDIDA=sd.COD_UNIDAD_MEDIDA),sd.CANTIDAD_SALIDA_ALMACEN ";
        sqla += " from SALIDAS_ALMACEN_DETALLE sd, salidas_ALMACEN SA  where sd.COD_SALIDA_ALMACEN=sa.COD_SALIDA_ALMACEN AND sa.COD_LOTE_PRODUCCION='" + COD_LOTE_PRODUCCION+"'";
        sqla += " order by 1";
        System.out.println("SQLAAAAAAA---> "+ sqla);
        Statement sta = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rsa  = sta.executeQuery(sqla);        
        
        String nomp = "";
        int Cant = 0;
        String CodUniMedida = "";
        String codMat = "";
        
        while (rsa.next()){
            String NOMBRE_MATERIAL = rsa.getString(1);
            String CODIGO_MATERIAL = rsa.getString(2);
            String ABREVIATURA = rsa.getString(3);
            int cantidad = rsa.getInt(4);
        ///Saco la suma de las cantidades
            
            String sqlb = "";
            sqlb  = " select sal.COD_LOTE_PRODUCCION,SAD.COD_MATERIAL,sum(sad.CANTIDAD_SALIDA_ALMACEN)as Cantidad_Salida,( "; 
            sqlb += " select  sum(dd.CANTIDAD_DEVUELTA) from DEVOLUCIONES d, DEVOLUCIONES_DETALLE_ETIQUETAS dd,SALIDAS_ALMACEN s ";
            sqlb += " where d.COD_ALMACEN = s.COD_ALMACEN and dd.COD_DEVOLUCION = d.COD_DEVOLUCION  and  d.COD_SALIDA_ALMACEN = s.COD_SALIDA_ALMACEN and ";
            sqlb += " s.COD_LOTE_PRODUCCION = '"+ COD_LOTE_PRODUCCION +"' AND DD.COD_MATERIAL="+ CODIGO_MATERIAL +") as Cantidad_Devuelta from SALIDAS_ALMACEN sal, ";
            sqlb += " SALIDAS_ALMACEN_DETALLE sad where sal.COD_SALIDA_ALMACEN = sad.COD_SALIDA_ALMACEN and sad.COD_MATERIAL = "+ CODIGO_MATERIAL +" and ";
            sqlb += " sal.COD_LOTE_PRODUCCION = '"+ COD_LOTE_PRODUCCION +"'";
            sqlb += " group by sal.COD_LOTE_PRODUCCION,SAD.COD_MATERIAL";

            System.out.println("sqlBBBBBB---> " + sqlb);
            Statement stb = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rsb = stb.executeQuery(sqlb);
            
            rsb.last();             
            rowcount = rsb.getRow(); 
            System.out.println("NUMERO DE FILAS EXISTENTES ======================>: "+rowcount);            
            rsb.beforeFirst();

            
       if(rowcount > 0){
            double NETA ;
            while (rsb.next()){             
               int  CANTIDAD_SALIDA_ALMACEN = rsb.getInt(3);
               int  CANTIDAD_DEVUELTA = rsb.getInt(4);
               NETA = cantidad - CANTIDAD_DEVUELTA;
               
               /*SACO LOS DATOS DE LA BASE DE DATOS ATLAS cantidad, la abreviatura*/
               String sqlc = "";               
               sqlc  = " select b.CANTIDAD,(select u.ABREVIATURA from UNIDADES_MEDIDA u where u.COD_UNIDAD_MEDIDA = b.COD_UNIDAD_MEDIDA ) as Unidades";
               sqlc += " from FORMULA_MAESTRA a,FORMULA_MAESTRA_DETALLE_MP b where a.COD_FORMULA_MAESTRA= b.COD_FORMULA_MAESTRA and  ";               
               sqlc += " a.COD_COMPPROD in( " + codigosPrograma + ")";
               sqlc += " and b.COD_MATERIAL =  " + CODIGO_MATERIAL ;                              
               System.out.println("SQLCCCCCC---->"+ sqlc);
               Statement stc = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
               ResultSet rsc = stc.executeQuery(sqlc);
               String UNIDADESMEDIDA = "";
               int CANTIDADDISPONIBLE = 0;
               double CANT ;
               double PORCENTAJE ;
               String PORCCARACTER = "";
               String ABREVIATURAS= "";               
               while (rsc.next()){
                     CANTIDADDISPONIBLE = rsc.getInt(1);
                     ABREVIATURAS = rsc.getString(2);
                     CANT = NETA - CANTIDADDISPONIBLE;
                     if(PORCENTAJE_VARIACION != ""){ 
                       PORCENTAJE = Math.round(((CANT / CANTIDADDISPONIBLE)*100));
                     }else{
                       PORCENTAJE =Integer.parseInt(PORCENTAJE_VARIACION);
                     }
                     PORCCARACTER = PORCENTAJE + " %";
        %>  
        
        <tr>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;">&nbsp;    </td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;"> <%=formatoFecha.format(FECHASAL)%>   </td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;" ><%=NOMBRE_MATERIAL%></td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=ABREVIATURA%></td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(cantidad)%></td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(CANTIDAD_DEVUELTA)%>    </td>            
            <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(NETA)%>    </td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=ABREVIATURAS%></td>
            
            <td class=colh align="left" style="border : solid #f2f2f2 1px;"> <%=form.format(CANTIDADDISPONIBLE)%>   </td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(CANT)%>   </td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;"> <%=PORCCARACTER%>    </td>
        </tr>
        <%
            } 
           }
          }else{ 
         %>
         
         <tr>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;">&nbsp;    </td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;"> <%=formatoFecha.format(FECHASAL)%>   </td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;" ><%=NOMBRE_MATERIAL%></td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=ABREVIATURA%></td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;">&nbsp;</td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;">&nbsp;</td>            
            <td class=colh align="left" style="border : solid #f2f2f2 1px;">&nbsp;</td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;">&nbsp;</td>
            
            <td class=colh align="left" style="border : solid #f2f2f2 1px;">&nbsp;</td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;">&nbsp;</td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;">&nbsp;</td>
        </tr>
         
         
         <%   
           }//fin de IF   
          } // while A
      %>
        <tr>
            <td class=colh align="center" style="border : solid #f2f2f2 1px;"><b>EMPAQUE PRIMARIO </b>   </td>            
        </tr>
        <%
        //Saco el nombre del producto
        sqla = "";
        sqla  = " select (select m.NOMBRE_MATERIAL from MATERIALES m where m.COD_MATERIAL = sd.COD_MATERIAL) as NOMBRE, ";
        sqla += " sd.COD_MATERIAL , ";
        sqla += " (select u.ABREVIATURA from UNIDADES_MEDIDA u where u.COD_UNIDAD_MEDIDA=sd.COD_UNIDAD_MEDIDA),sd.CANTIDAD_SALIDA_ALMACEN ";
        sqla += " from SALIDAS_ALMACEN_DETALLE sd, salidas_ALMACEN SA  where sd.COD_SALIDA_ALMACEN=sa.COD_SALIDA_ALMACEN AND sa.COD_LOTE_PRODUCCION='" + COD_LOTE_PRODUCCION+"'";
        sqla += " order by 1";
        
        System.out.println("SQLAAAAAAA---> "+ sqla);
        sta = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        rsa  = sta.executeQuery(sqla);
        nomp = "";
        Cant = 0;
        CodUniMedida = "";
        codMat = "";
        
        while (rsa.next()){
            String NOMBRE_MATERIAL = rsa.getString(1);
            String CODIGO_MATERIAL = rsa.getString(2);
            String ABREVIATURA = rsa.getString(3);
            int cantidad = rsa.getInt(4);
           ///Saco la suma de las cantidades
            
            String sqlb = "";
            sqlb  = " select sal.COD_LOTE_PRODUCCION,SAD.COD_MATERIAL,sum(sad.CANTIDAD_SALIDA_ALMACEN)as Cantidad_Salida,( "; 
            sqlb += " select  sum(dd.CANTIDAD_DEVUELTA) from DEVOLUCIONES d, DEVOLUCIONES_DETALLE_ETIQUETAS dd,SALIDAS_ALMACEN s ";
            sqlb += " where d.COD_ALMACEN = s.COD_ALMACEN and dd.COD_DEVOLUCION = d.COD_DEVOLUCION  and  d.COD_SALIDA_ALMACEN = s.COD_SALIDA_ALMACEN and ";
            sqlb += " s.COD_LOTE_PRODUCCION = '"+ COD_LOTE_PRODUCCION +"' AND DD.COD_MATERIAL="+ CODIGO_MATERIAL +") as Cantidad_Devuelta from SALIDAS_ALMACEN sal, ";
            sqlb += " SALIDAS_ALMACEN_DETALLE sad where sal.COD_SALIDA_ALMACEN = sad.COD_SALIDA_ALMACEN and sad.COD_MATERIAL = "+ CODIGO_MATERIAL +" and ";
            sqlb += " sal.COD_LOTE_PRODUCCION = '"+ COD_LOTE_PRODUCCION +"'";
            sqlb += " group by sal.COD_LOTE_PRODUCCION,SAD.COD_MATERIAL";
            
            
            System.out.println("sqlBBBBBB---> " + sqlb);
            Statement stb = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rsb = stb.executeQuery(sqlb);
            
            rsb.last();             
            rowcount = rsb.getRow(); 
            System.out.println("NUMERO DE FILAS EXISTENTES ======================>: "+rowcount);            
            rsb.beforeFirst();
       if(rowcount > 0){
            double NETA ;
            while (rsb.next()){
             
               int  CANTIDAD_SALIDA_ALMACEN = rsb.getInt(3);
               int  CANTIDAD_DEVUELTA = rsb.getInt(4);
               NETA = cantidad - CANTIDAD_DEVUELTA;
               
               /*SACO LOS DATOS DE LA BASE DE DATOS ATLAS cantidad, la abreviatura*/
               String sqlc = "";               
               sqlc  = " select b.CANTIDAD,(select u.ABREVIATURA from UNIDADES_MEDIDA u where u.COD_UNIDAD_MEDIDA = b.COD_UNIDAD_MEDIDA ) as Unidades";
               sqlc += " from FORMULA_MAESTRA a,FORMULA_MAESTRA_DETALLE_EP b where a.COD_FORMULA_MAESTRA= b.COD_FORMULA_MAESTRA and  ";               
               sqlc += " a.COD_COMPPROD in( " + codigosPrograma +")";
               sqlc += " and b.COD_MATERIAL =  " + CODIGO_MATERIAL ;               
               System.out.println("SQLCCCCCC---->"+ sqlc);
               Statement stc = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
               ResultSet rsc = stc.executeQuery(sqlc);
               
               

               
               String UNIDADESMEDIDA = "";
               int CANTIDADDISPONIBLE = 0;
               double CANT ;
               double PORCENTAJE ;
               String PORCCARACTER = "";
               String ABREVIATURAS= "";               
               while (rsc.next()){
                     CANTIDADDISPONIBLE = rsc.getInt(1);
                     ABREVIATURAS = rsc.getString(2);
                     CANT = NETA - CANTIDADDISPONIBLE;
                     
                     if(PORCENTAJE_VARIACION != ""){ 
                       PORCENTAJE = Math.round(((CANT / CANTIDADDISPONIBLE)*100));
                     }else{
                       PORCENTAJE =Integer.parseInt(PORCENTAJE_VARIACION);
                     }
                     
                     PORCCARACTER = PORCENTAJE + " %";
        %>  
        <tr>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;">&nbsp;    </td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=formatoFecha.format(FECHASAL)%>    </td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;" ><%=NOMBRE_MATERIAL%></td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=ABREVIATURA%></td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(cantidad)%></td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(CANTIDAD_DEVUELTA)%>    </td>            
            <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(NETA)%>    </td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=ABREVIATURAS%></td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;"> <%=form.format(CANTIDADDISPONIBLE)%>   </td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(CANT)%>   </td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;"> <%=PORCCARACTER%>    </td>
        </tr>
        <%
            }//fin de while C 
           }// fin de while B
          }else{  
        %>
         <tr>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;">&nbsp;    </td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;"> <%=formatoFecha.format(FECHASAL)%>   </td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;" ><%=NOMBRE_MATERIAL%></td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=ABREVIATURA%></td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;">&nbsp;</td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;">&nbsp;</td>            
            <td class=colh align="left" style="border : solid #f2f2f2 1px;">&nbsp;</td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;">&nbsp;</td>
            
            <td class=colh align="left" style="border : solid #f2f2f2 1px;">&nbsp;</td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;">&nbsp;</td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;">&nbsp;</td>
        </tr>
        <%
          } // fin de IF 
          }//fin de while A
       %>
        <tr>
            <td class=colh align="center" style="border : solid #f2f2f2 1px;"><b>EMPAQUE SECUNDARIO</b>   </td>            
        </tr>
        <%
        //Saco el nombre del producto
        sqla = "";
        sqla  = " select (select m.NOMBRE_MATERIAL from MATERIALES m where m.COD_MATERIAL = sd.COD_MATERIAL) as NOMBRE, ";
        sqla += " sd.COD_MATERIAL , ";
        sqla += " (select u.ABREVIATURA from UNIDADES_MEDIDA u where u.COD_UNIDAD_MEDIDA=sd.COD_UNIDAD_MEDIDA),sd.CANTIDAD_SALIDA_ALMACEN ";
        sqla += " from SALIDAS_ALMACEN_DETALLE sd, salidas_ALMACEN SA  where sd.COD_SALIDA_ALMACEN=sa.COD_SALIDA_ALMACEN AND sa.COD_LOTE_PRODUCCION='" + COD_LOTE_PRODUCCION+"'";
        sqla += " order by 1";
        
        System.out.println("SQLAAAAAAA---> "+ sqla);
        sta = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        rsa  = sta.executeQuery(sqla);
        nomp = "";
        Cant = 0;
        CodUniMedida = "";
        codMat = "";
        
        while (rsa.next()){
            String NOMBRE_MATERIAL = rsa.getString(1);
            String CODIGO_MATERIAL = rsa.getString(2);
            String ABREVIATURA = rsa.getString(3);
            int cantidad = rsa.getInt(4);
        ///Saco la suma de las cantidades
            
            String sqlb = "";
            sqlb  = " select sal.COD_LOTE_PRODUCCION,SAD.COD_MATERIAL,sum(sad.CANTIDAD_SALIDA_ALMACEN)as Cantidad_Salida,( "; 
            sqlb += " select  sum(dd.CANTIDAD_DEVUELTA) from DEVOLUCIONES d, DEVOLUCIONES_DETALLE_ETIQUETAS dd,SALIDAS_ALMACEN s ";
            sqlb += " where d.COD_ALMACEN = s.COD_ALMACEN and dd.COD_DEVOLUCION = d.COD_DEVOLUCION  and  d.COD_SALIDA_ALMACEN = s.COD_SALIDA_ALMACEN and ";
            sqlb += " s.COD_LOTE_PRODUCCION = '"+ COD_LOTE_PRODUCCION +"' AND DD.COD_MATERIAL="+ CODIGO_MATERIAL +") as Cantidad_Devuelta from SALIDAS_ALMACEN sal, ";
            sqlb += " SALIDAS_ALMACEN_DETALLE sad where sal.COD_SALIDA_ALMACEN = sad.COD_SALIDA_ALMACEN and sad.COD_MATERIAL = "+ CODIGO_MATERIAL +" and ";
            sqlb += " sal.COD_LOTE_PRODUCCION = '"+ COD_LOTE_PRODUCCION +"'";
            sqlb += " group by sal.COD_LOTE_PRODUCCION,SAD.COD_MATERIAL";            
            System.out.println("sqlBBBBBB---> " + sqlb);
            Statement stb = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rsb = stb.executeQuery(sqlb);
            
            rsb.last();             
            rowcount = rsb.getRow(); 
            System.out.println("NUMERO DE FILAS EXISTENTES ======================>: "+rowcount);            
            rsb.beforeFirst();
       if(rowcount > 0){            
            
            double NETA ;
            while (rsb.next()){             
               int  CANTIDAD_SALIDA_ALMACEN = rsb.getInt(3);
               int  CANTIDAD_DEVUELTA = rsb.getInt(4);
               NETA = cantidad - CANTIDAD_DEVUELTA;
               
               /*SACO LOS DATOS DE LA BASE DE DATOS ATLAS cantidad, la abreviatura*/
               String sqlc = "";               
               sqlc  = " select b.CANTIDAD,(select u.ABREVIATURA from UNIDADES_MEDIDA u where u.COD_UNIDAD_MEDIDA = b.COD_UNIDAD_MEDIDA ) as Unidades";
               sqlc += " from FORMULA_MAESTRA a,FORMULA_MAESTRA_DETALLE_ES b where a.COD_FORMULA_MAESTRA= b.COD_FORMULA_MAESTRA and  ";               
               sqlc += " a.COD_COMPPROD in (" + codigosPrograma + ")";
               sqlc += " and b.COD_MATERIAL =  " + CODIGO_MATERIAL ;               
               System.out.println("SQLCCCCCC---->"+ sqlc);
               Statement stc = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
               ResultSet rsc = stc.executeQuery(sqlc);
               
               String UNIDADESMEDIDA = "";
               int CANTIDADDISPONIBLE = 0;
               double CANT ;
               double PORCENTAJE ;
               String PORCCARACTER = "";
               String ABREVIATURAS= "";               
               while (rsc.next()){
               //  if (rsc.next()){
                     CANTIDADDISPONIBLE = rsc.getInt(1);
                     ABREVIATURAS = rsc.getString(2);
                     CANT = NETA - CANTIDADDISPONIBLE;
                     if(PORCENTAJE_VARIACION != ""){ 
                       PORCENTAJE = Math.round(((CANT / CANTIDADDISPONIBLE)*100));
                     }else{
                       PORCENTAJE =Integer.parseInt(PORCENTAJE_VARIACION);
                     }
                     PORCCARACTER = PORCENTAJE + " %";
                 // }
        %> 
        <tr>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;">&nbsp;    </td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=formatoFecha.format(FECHASAL)%>    </td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;" ><%=NOMBRE_MATERIAL%></td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=ABREVIATURA%></td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(cantidad)%></td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(CANTIDAD_DEVUELTA)%>    </td>            
            <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(NETA)%>    </td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=ABREVIATURAS%></td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;"> <%=form.format(CANTIDADDISPONIBLE)%>   </td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(CANT)%>   </td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;"> <%=PORCCARACTER%>    </td>

        </tr>
        <%
            }//finde while C  
           }// fin de while B
           }else{ // finde IF 
         %>
         <tr>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;">&nbsp;    </td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;"> <%=formatoFecha.format(FECHASAL)%>   </td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;" ><%=NOMBRE_MATERIAL%></td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=ABREVIATURA%></td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;">&nbsp;</td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;">&nbsp;</td>            
            <td class=colh align="left" style="border : solid #f2f2f2 1px;">&nbsp;</td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;">&nbsp;</td>
            
            <td class=colh align="left" style="border : solid #f2f2f2 1px;">&nbsp;</td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;">&nbsp;</td>
            <td class=colh align="left" style="border : solid #f2f2f2 1px;">&nbsp;</td>
        </tr>    
         <%
          }//fin de  IF
          } // fin de while A
        }
      %>
    </table>
    <br>
    <br>
    <div align="center">
    </div>
    </form>
</body>
</html>






