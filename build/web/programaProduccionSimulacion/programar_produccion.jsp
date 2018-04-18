<%@ page import="java.sql.*" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.joda.time.*" %>
<%@ page import="com.cofar.bean.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import = "java.text.DecimalFormat"%> 
<%@ page import = "java.text.NumberFormat"%> 
<%@ page import = "java.util.Locale"%>

<%! Connection con = null;
%>
<style type="text/css">
    .tituloCampo1{
    font-family: Verdana, Arial, Helvetica, sans-serif;
    font-size: 11px;
    font-weight: bold;
    }
    .outputText3{
    font-family: Verdana, Arial, Helvetica, sans-serif;
    font-size: 11px;
    }
    .inputText3{
    font-family: Verdana, Arial, Helvetica, sans-serif;
    font-size: 11px;
    }
    .commandButtonR{
    font-family: Verdana, Arial, Helvetica, sans-serif;
    font-size: 11px;
    width: 150px;
    height: 20px;
    background-repeat :repeat-x;
    
    background-image: url('../img/bar3.png');
    }
</style>
<script >

    cod_error=new Array();
    function mandar(f){


        /*var elements=document.getElementById(nametable);
        var rowsElement=elements.rows;
        var codProgramaPeriodo=0;
        for(var i=1;i<rowsElement.length;i++){
            var cellsElement=rowsElement[i].cells;
            var cel=cellsElement[0];
            var celda=cel.getElementsByTagName('input')[0];
            if(celda!=null){
                if(celda.type=='checkbox'){
                    if(celda.checked){
                        count++;
                        codProgramaPeriodo=celda.value;
                    }
                }
            }
        }    */



        //alert();
        var i;
        var j=0;
        var g=0;

        cod_mal=new Array();
        for(i=0;i<=f.length-3;i++)
        {
            if(f.elements[i].type=='checkbox')
            {
                if(f.elements[i].name=="lote_prod"){
                    if(f.elements[i].checked){
                        cod_error[j]=f.elements[i].value;
                        j++;
                        cod_error[j]=f.elements[i+1].value;
                        //alert(cod_error[j]);
                        j++;

                    }
                }
            }
        }
        //alert(cod_error);
        if(j==0 && g==0)
        {	//alert('Debe seleccionar almenos un Registro para ser Registrado.');
            var aprob=f.aprobados.value;
            //alert(f.codProgramaProd.value);
            //location.href="guardar_programar_produccion.jsf?codProgramaPeriodo="+f.codProgramaProd.value+"&cod_aprobados="+aprob;
            window.close();
        }
        else
        {
            var aprob=f.aprobados.value;
            //alert(cod_error+"----"+aprob);
            location.href="guardar_programar_produccion.jsf?codProgramaPeriodo="+f.codProgramaProd.value+"&cod_lotes_anterior="+aprob+"&cod_comp_prod="+cod_error;
            window.close();
        }
    }
                                </script>

<html>
    <head>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script type="text/javascript" src="../js/general.js"></script>
    </head>
    <body>
        <form method="post" name="form1">
            <%
            try {
                con = Util.openConnection(con);
                String codProgramaPeriodo = request.getParameter("codProgramaPeriodo");
                String codAprobados = request.getParameter("cod_aprobados");
                String transito=request.getParameter("transito");
                System.out.println("codProgramaPeriodo:" + codProgramaPeriodo);
                System.out.println("codAprobados:" + codAprobados);
                System.out.println("transito:" + transito);
                String loteProduccion = "";
                String material_transito="0";
                int loteProduccionLiquidos = 0;
                String aprobados = "";
                String codLote="";
            /*ManagedProgramaProduccionSimulacion obj=(ManagedProgramaProduccionSimulacion)Util.getSessionBean("ManagedProgramaProduccionSimulacion");
            System.out.println("codProgramaPeriodo:"+obj.getProgramaProduccionList());
            List<ProgramaProduccion> iter = obj.getProgramaProduccionList();*/
                String sqlUpdProgProd = "update programa_produccion_periodo set cod_estado_programa=2 where cod_programa_prod=" + codProgramaPeriodo;
                Statement stUpdProgProd = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                stUpdProgProd.executeUpdate(sqlUpdProgProd);
                
                sqlUpdProgProd = "select  pp.COD_COMPPROD,pp.CANT_LOTE_PRODUCCION,pp.FECHA_INICIO,pp.FECHA_FINAL," +
                        " pp.COD_FORMULA_MAESTRA,pp.OBSERVACION,pp.COD_TIPO_PROGRAMA_PROD";
                sqlUpdProgProd += " from PROGRAMA_PRODUCCION pp";
                sqlUpdProgProd += " where pp.COD_COMPPROD in (" + codAprobados + ")";
                sqlUpdProgProd += " and pp.cod_programa_prod='" + codProgramaPeriodo + "'";
                System.out.println("sqlUpdProgProd ***** ::::" + sqlUpdProgProd);
                stUpdProgProd = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rsUpdProgProd = stUpdProgProd.executeQuery(sqlUpdProgProd);
                while (rsUpdProgProd.next()) {
                    String codCompProd = rsUpdProgProd.getString(1);
                    int cantidad_lote = rsUpdProgProd.getInt(2);
                    String codFormulaMaestra = rsUpdProgProd.getString(5);
                    String obsProgProd = rsUpdProgProd.getString(6);
                    codLote = rsUpdProgProd.getString(7);
                    if(codLote.equals("1")){
                        codLote="-";
                    }
                    if(codLote.equals("2")){
                        codLote="--";
                    }
                    if(codLote.equals("3")){
                        codLote="---";
                    }
                    
                    System.out.println("cantidad_lote*****************************:" + cantidad_lote);
                    String loteFormaFarmaceutica = "";
                    
                    System.out.println("ENTRO");
                    //GENERAMOS EL NUMERO DE LOTE
                    String sqlFormaFar = "select cod_forma from componentes_prod where cod_compprod=" + codCompProd;
                    Statement stFormaFar = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet rsFormaFar = stFormaFar.executeQuery(sqlFormaFar);
                    String formaFarmaceutica = "";
                    if (rsFormaFar.next()) {
                        formaFarmaceutica = rsFormaFar.getString(1);
                    }
                    String formaFarmaceuticaComparar = "";
                    System.out.println("FORMA FARMACEUTICA 1: " + formaFarmaceutica);
                    if (formaFarmaceutica.equals("2")) {
                        loteFormaFarmaceutica = "1";
                        formaFarmaceuticaComparar = "2";
                    }
                    if (formaFarmaceutica.equals("1")) {
                        loteFormaFarmaceutica = "2";
                        formaFarmaceuticaComparar = "1";
                    }
                    if (formaFarmaceutica.equals("7") || formaFarmaceutica.equals("10") || formaFarmaceutica.equals("16") || formaFarmaceutica.equals("17") || formaFarmaceutica.equals("26") || formaFarmaceutica.equals("29")) {
                        loteFormaFarmaceutica = "3";
                        formaFarmaceuticaComparar = "7,10,16,26,29";
                    }
                    if (formaFarmaceutica.equals("11") || formaFarmaceutica.equals("12") || formaFarmaceutica.equals("13") || formaFarmaceutica.equals("31")) {
                        loteFormaFarmaceutica = "4";
                        formaFarmaceuticaComparar = "11,12,13,31";
                    }
                    if (formaFarmaceutica.equals("25") || formaFarmaceutica.equals("27")) {
                        loteFormaFarmaceutica = "7";
                        formaFarmaceuticaComparar = "25,27";
                    }
                    if (formaFarmaceutica.equals("6") || formaFarmaceutica.equals("8")  || formaFarmaceutica.equals("14") || formaFarmaceutica.equals("15")  || formaFarmaceutica.equals("32")) {
                        loteFormaFarmaceutica = "8";
                        formaFarmaceuticaComparar = "6,8,14,15,32";
                    }
                    if (formaFarmaceutica.equals("20")|| formaFarmaceutica.equals("30") ) {
                        loteFormaFarmaceutica = "9";
                        formaFarmaceuticaComparar = "20,30";
                    }
                    
                    DateTime dt = new DateTime();
                    int loteMes = dt.getMonthOfYear();
                    int loteAnio = dt.getYear();
                    String loteAnio2 = Integer.toString(loteAnio).substring(3, 4);
                    String loteMes2 = "";
                    if (loteMes < 10) {
                        loteMes2 = "0" + Integer.toString(loteMes);
                    } else {
                        loteMes2 = Integer.toString(loteMes);
                    }
                    //sacamos el ultimo dia del mes
                    DateTime dt1 = dt.plusMonths(1);
                    dt1 = dt1.minusDays(1);
                    DateTime dt2 = new DateTime(dt1.getYear(), dt1.getMonthOfYear(), 1, 12, 0, 0, 0);
                    dt2 = dt2.minusDays(1);
                    String primerDiaMes = Integer.toString(dt2.getYear()) + "-" + Integer.toString(dt2.getMonthOfYear()) + "-1";
                    String ultimoDiaMes = Integer.toString(dt2.getYear()) + "-" + Integer.toString(dt2.getMonthOfYear()) + "-" + Integer.toString(dt2.getDayOfMonth());
                    System.out.println("ULTIMO DIA MES: " + ultimoDiaMes);
                    System.out.println("loteMes: " + loteMes);
                    System.out.println("loteAnio2: " + loteAnio2);
                    
                    /**********************************************/
                    /***********************************************/
                    loteProduccion = "";
                    loteProduccionLiquidos = 0;
                    String codReserva = "";
                    
                    
                    for (int i = 1; i <= cantidad_lote; i++) {
                        
                        
                        System.out.println("****************************************i: " + i);
                        String sqlNumProduccion = "select count(*)+1 from PROGRAMA_PRODUCCION p, componentes_prod c where p.COD_PROGRAMA_PROD = " + codProgramaPeriodo + " and " +
                                " p.COD_ESTADO_PROGRAMA=2  and" +
                                " c.cod_compprod=p.cod_compprod and c.cod_forma in (" + formaFarmaceuticaComparar + ")";
                        Statement stNumProduccion = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                        System.out.println("SQL NUM PRODUCCION: " + sqlNumProduccion);
                        ResultSet rsNumProduccion = stNumProduccion.executeQuery(sqlNumProduccion);
                        
                        int numProduccion = 0;
                        while (rsNumProduccion.next()) {
                            numProduccion = rsNumProduccion.getInt(1);
                        }
                        String numProduccionString = "";
                        if (numProduccion < 10) {
                            numProduccionString = "0" + numProduccion;
                        } else {
                            numProduccionString = "" + numProduccion;
                        }
                        if (loteFormaFarmaceutica.equals("1")) {
                            loteProduccionLiquidos = loteProduccionLiquidos + 1;
                            loteProduccion = "S-L " + loteProduccionLiquidos;
                        } else {
                            loteProduccion = loteFormaFarmaceutica + loteMes2 + numProduccionString + loteAnio2;
                        }
                        System.out.println("FORMA FARMACEUTICA: " + loteFormaFarmaceutica);
                        System.out.println("LOTE MES: " + loteMes);
                        System.out.println("LOTE ANIO: " + loteAnio2);
                        
                        System.out.println("LOTE DE PRODUCCION:  " + loteProduccion);
                        //ACTUALIZAR EL LOTE DEL PRODUCTO
                        
                        
                        String sql = "select pp.COD_TIPO_PROGRAMA_PROD";
                        sql += " from PROGRAMA_PRODUCCION pp";
                        sql += " where  pp.COD_FORMULA_MAESTRA='" + codFormulaMaestra + "' and pp.cod_programa_prod=" + codProgramaPeriodo + "";
                        sql += " and pp.COD_COMPPROD=" + codCompProd + " and pp.COD_LOTE_PRODUCCION='"+codLote+"'";
                        Statement st_form1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                        System.out.println("SQL NUM Detalle  " + sql);
                        ResultSet rs_form1 = st_form1.executeQuery(sql);
                        Statement stUpdLote = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                        
                        while (rs_form1.next()) {
                            String codTipoPrograma = rs_form1.getString(1);
                            String sql_transito=" select COUNT(COD_COMPPROD) from programa_produccion where COD_COMPPROD in ("+transito+") AND COD_FORMULA_MAESTRA='" + codFormulaMaestra + "'";
                            sql_transito+=" AND cod_programa_prod='"+codProgramaPeriodo+"' AND COD_COMPPROD='"+codCompProd+"' AND cod_lote_produccion='" + codLote + "'";
                            System.out.println("sql_transito  " + sql_transito);
                            Statement st_transito = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            ResultSet rs_transito = st_transito.executeQuery(sql_transito);
                            int sw_transito=0;
                            while(rs_transito.next()){
                                sw_transito=rs_transito.getInt(1);
                                System.out.println(":" + sw_transito);
                            }
                            material_transito="0";
                            if(sw_transito!=0){
                                System.out.println("ENTRO QQQQ:  " + material_transito);
                                material_transito="1";
                            }
                            System.out.println("material_transito:  " + material_transito);
                            sql = "insert into programa_produccion(cod_programa_prod,cod_formula_maestra,cod_lote_produccion,";
                            sql += " cod_estado_programa,observacion,CANT_LOTE_PRODUCCION,VERSION_LOTE,COD_COMPPROD,COD_TIPO_PROGRAMA_PROD,MATERIAL_TRANSITO)values(";
                            sql += " " + codProgramaPeriodo + ",'" + codFormulaMaestra + "','" + loteProduccion + "',";
                            sql += " 2,'" + obsProgProd + "','1',1," + codCompProd + ",'" + codTipoPrograma + "',"+material_transito+")";
                            System.out.println("insert 1:" + sql);
                            
                            stUpdLote.executeUpdate(sql);
                            
                        }
                        sql = "select ppd.COD_MATERIAL,ppd.COD_UNIDAD_MEDIDA,(ppd.CANTIDAD /pp.CANT_LOTE_PRODUCCION)";
                        sql += " from PROGRAMA_PRODUCCION_DETALLE ppd,PROGRAMA_PRODUCCION pp";
                        sql += " where pp.COD_PROGRAMA_PROD=ppd.COD_PROGRAMA_PROD AND";
                        sql += " pp.COD_LOTE_PRODUCCION=ppd.COD_LOTE_PRODUCCION";
                        sql += " and ppd.COD_COMPPROD=pp.COD_COMPPROD and pp.COD_FORMULA_MAESTRA='" + codFormulaMaestra + "'";
                        sql += " and ppd.COD_COMPPROD=" + codCompProd + " and ppd.COD_LOTE_PRODUCCION='"+codLote+"' and pp.cod_programa_prod=" + codProgramaPeriodo + "";
                        Statement st_form = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                        System.out.println("SQL NUM Detalle  " + sql);
                        ResultSet rs_form = st_form.executeQuery(sql);
                        while (rs_form.next()) {
                            String cod_material = rs_form.getString(1);
                            String cod_unidad_medida = rs_form.getString(2);
                            double cantidad = rs_form.getDouble(3);
                            sql = " insert into programa_produccion_detalle(cod_programa_prod,cod_material,cod_unidad_medida,cantidad," +
                                    " COD_COMPPROD,cod_lote_produccion) values(";
                            sql += " " + codProgramaPeriodo + ",'" + cod_material + "','" + cod_unidad_medida + "'," + cantidad + ",";
                            sql += " " + codCompProd + ",'" + loteProduccion + "')";
                            System.out.println("insert ep:" + sql);
                            stUpdLote = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            stUpdLote.executeUpdate(sql);
                            
                        }
                        
                    }
                    String sqlUpdLote = "delete from programa_produccion  " +
                            " where cod_programa_prod=" + codProgramaPeriodo + " " +
                            " and cod_compprod=" + codCompProd + "" +
                            " and cod_lote_produccion='"+codLote+"'";
                    Statement stUpdLote = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    stUpdLote.executeUpdate(sqlUpdLote);
                    System.out.println("ACTUALIZA LOTE: " + sqlUpdLote);
                    
                    sqlUpdLote = "delete from programa_produccion_detalle  " +
                            " where cod_programa_prod=" + codProgramaPeriodo + " " +
                            " and cod_compprod=" + codCompProd + "" +
                            " and cod_lote_produccion='"+codLote+"'";
                    stUpdLote = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    stUpdLote.executeUpdate(sqlUpdLote);
                    System.out.println("ACTUALIZA LOTE Detalle--: " + sqlUpdLote);
                    
                }
            
            %>
            
            <div align="center" class="outputText2">
                
                
                <h3 > Asignar Lotes que Pertenecen a Líquidos </h3>
                <table border="0" class="outputText2" id="lotes_tabla" style="border:1px solid #000000"  width="95%">
                    <tr class="headerClassACliente">
                        <td colspan="2" align="center">
                            <div class="outputText2"><b>Producto</b></div>
                        </td>
                        
                        <td>
                            <div class="outputText2"><b>Lote</b></div>
                        </td>
                        <td colspan="2" align="center">
                            <div class="outputText2"><b>Cant Lote</b></div>
                        </td>
                        <td colspan="2" align="center">
                            <div class="outputText2"><b>Tipo Mercadería</b></div>
                        </td>
                    </tr>
                    <%
                    // for(String c:estadoMal){
                    String sql = "select c.COD_COMPPROD,c.nombre_prod_semiterminado,pp.cod_lote_produccion,pp.cant_lote_produccion,tp.NOMBRE_TIPO_PROGRAMA_PROD,";
                    sql += " pp.CANT_LOTE_PRODUCCION";
                    sql += " from COMPONENTES_PROD c,programa_produccion pp,TIPOS_PROGRAMA_PRODUCCION tp";
                    sql += " where c.COD_COMPPROD in (" + codAprobados + ") and c.COD_COMPPROD <> -1 and pp.cod_programa_prod=" + codProgramaPeriodo + "";
                    sql += " and c.cod_forma = 2 and pp.cod_compprod=c.cod_compprod and tp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD";
                    System.out.println("sql navegador Mal:" + sql);
                    Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs = st.executeQuery(sql);
                    rs.last();
                    int rows = rs.getRow();
                    
                    rs.first();
                    String cod = "";
                    for (int i = 0; i < rows; i++) {
                        System.out.println("rs.getString(2):" + rs.getString(2));
                    
                    %>
                    <tr>
                        <td><input type="checkbox" name="lote_prod" id="lote_prod" value="<%=rs.getString(1)%>"> </td>
                        <td><%=rs.getString(2)%></td>
                        <td><input type="text" class="inputText" name="lote"  value="<%=rs.getString(3)%>"></td>
                        <td><input type="text" class="inputText" name="lote"  value="<%=rs.getString(4)%>"></td>
                        <td><input type="text" class="inputText" name="lote"  value="<%=rs.getString(5)%>"></td>
                    </tr>
                    <%
                    aprobados = aprobados + "," + rs.getString(3);
                    rs.next();
                    }
                    
                    %>
                    
                </table>
                <input type="hidden" name="codProgramaProd" value="<%=codProgramaPeriodo%>">
                <input type="hidden" name="aprobados" value="<%=aprobados%>">
                <br> <br> <br>
                <%
                } catch (Exception e) {
                    e.printStackTrace();
                }
                %>
                <input type="button" class="commandButtonR"   value="Guardar" name="guardar" onclick="return mandar(form1);">
            </div>
        </form>
    </body>
</html>