<%@ page import="java.sql.*" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.joda.time.*" %>
<%@ page import="com.cofar.bean.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%! Connection con=null;
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
            function mandar(f){
                if(f.nombrePrograma.value==""){
                    alert("Nombre vacio.");
                    f.nombrePrograma.focus();
                    return false;
                }
                if(confirm('Está seguro de Guardar los datos.')){
                    f.action="guardar_modificacion_periodo.jsf";
                    f.nombreProgramaF.value=f.nombrePrograma.value;
                    f.obsF.value=f.obs.value;
                    f.submit();
                }else{
                    return false;
                }
            }
</script>

<html>
    <head>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />        
        <script type="text/javascript" src="../js/general.js"></script>
    </head>
    <body>
        <%
        try{
            con=Util.openConnection(con);
            String codProgramaPeriodo=request.getParameter("codProgramaPeriodo");
            System.out.println("codProgramaPeriodo:"+codProgramaPeriodo);
            ManagedProgramaProduccionSimulacion obj=(ManagedProgramaProduccionSimulacion)Util.getSessionBean("ManagedProgramaProduccionSimulacion");
            System.out.println("codProgramaPeriodo:"+obj.getProgramaProduccionList());
            List<ProgramaProduccion> iter = obj.getProgramaProduccionList();
            String sqlUpdProgProd="update programa_produccion_periodo set cod_estado_programa=2 where cod_programa_prod="+codProgramaPeriodo;
            Statement stUpdProgProd=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            stUpdProgProd.executeUpdate(sqlUpdProgProd);
            for(ProgramaProduccion bean:iter){
                System.out.println("CODIGO PROGRAMA PROD: "+bean.getCodProgramaProduccion());
                System.out.println("CODIGO COMP PROD:  "+bean.getFormulaMaestra().getComponentesProd().getCodCompprod());
                System.out.println("CODIGO ESTADO SIMULACION: "+bean.getEstadoProductoSimulacion());
                bean.getCantidadLote();
                double cant_lote=Double.parseDouble(bean.getCantidadLote());
                int cantidad_lote=(int)cant_lote;
                System.out.println("cant_lote*****************************:"+cant_lote);
                String loteFormaFarmaceutica="";
                if(bean.getEstadoProductoSimulacion()==0 ){
                    System.out.println("ENTRO");
                    //GENERAMOS EL NUMERO DE LOTE
                    String sqlFormaFar="select cod_forma from componentes_prod where cod_compprod="+bean.getFormulaMaestra().getComponentesProd().getCodCompprod();
                    Statement stFormaFar=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet rsFormaFar=stFormaFar.executeQuery(sqlFormaFar);
                    String formaFarmaceutica="";
                    if(rsFormaFar.next()){
                        formaFarmaceutica=rsFormaFar.getString(1);
                    }
                    String formaFarmaceuticaComparar="";
                    System.out.println("FORMA FARMACEUTICA 1: "+formaFarmaceutica);
                    if(formaFarmaceutica.equals("2")){
                        loteFormaFarmaceutica="1";
                        formaFarmaceuticaComparar="2";
                    }
                    if(formaFarmaceutica.equals("1")){
                        loteFormaFarmaceutica="2";
                        formaFarmaceuticaComparar="1";
                    }
                    if(formaFarmaceutica.equals("7") || formaFarmaceutica.equals("10") || formaFarmaceutica.equals("16") || formaFarmaceutica.equals("26") || formaFarmaceutica.equals("29")){
                        loteFormaFarmaceutica="3";
                        formaFarmaceuticaComparar="7,10,16,26,29";
                    }
                    if(formaFarmaceutica.equals("11") || formaFarmaceutica.equals("12") || formaFarmaceutica.equals("13") || formaFarmaceutica.equals("31")){
                        loteFormaFarmaceutica="4";
                        formaFarmaceuticaComparar="11,12,13,31";
                    }
                    if(formaFarmaceutica.equals("25") || formaFarmaceutica.equals("27")){
                        loteFormaFarmaceutica="7";
                        formaFarmaceuticaComparar="25,27";
                    }
                    if(formaFarmaceutica.equals("6") || formaFarmaceutica.equals("14") || formaFarmaceutica.equals("20") || formaFarmaceutica.equals("30") || formaFarmaceutica.equals("32")){
                        loteFormaFarmaceutica="8";
                        formaFarmaceuticaComparar="6,14,20,30,32";
                    }
                    DateTime dt = new DateTime();
                    int loteMes=dt.getMonthOfYear();
                    int loteAnio=dt.getYear();
                    String loteAnio2=Integer.toString(loteAnio).substring(2,4);
                    //sacamos el ultimo dia del mes
                    DateTime dt1 = dt.plusMonths(1);
                    dt1=dt1.minusDays(1);
                    DateTime dt2 = new DateTime(dt1.getYear(), dt1.getMonthOfYear(), 1, 12, 0, 0, 0);
                    dt2=dt2.minusDays(1);
                    String primerDiaMes=Integer.toString(dt2.getYear())+"-"+Integer.toString(dt2.getMonthOfYear())+"-1";
                    String ultimoDiaMes=Integer.toString(dt2.getYear())+"-"+Integer.toString(dt2.getMonthOfYear())+"-"+Integer.toString(dt2.getDayOfMonth());
                    System.out.println("ULTIMO DIA MES: "+ultimoDiaMes);
                    
                    System.out.println("bean.getFechaInicio(): "+bean.getFechaInicio());
                    System.out.println("bean.getFechaFinal(): "+bean.getFechaFinal());
                    String fechaInicio[]=bean.getFechaInicio().split("/");
                    bean.setFechaInicio(fechaInicio[2]+"/"+fechaInicio[1]+"/"+fechaInicio[0]);
                    String fechaFinal[]=bean.getFechaFinal().split("/");
                    bean.setFechaFinal(fechaFinal[2]+"/"+fechaFinal[1]+"/"+fechaFinal[0]);
                    
                    /**********************************************/
                    
                    /***********************************************/
                    for (int i=1;i<=cantidad_lote;i++){
                        System.out.println("****************************************i: "+i);
                        String sqlNumProduccion="select count(*)+1 from PROGRAMA_PRODUCCION p, componentes_prod c where p.COD_PROGRAMA_PROD = "+bean.getCodProgramaProduccion()+" and " +
                                " p.FECHA_INICIO BETWEEN '"+primerDiaMes+"'  and '"+ultimoDiaMes+"' and p.COD_ESTADO_PROGRAMA=2 and " +
                                " c.cod_compprod=p.cod_compprod and c.cod_forma in ("+formaFarmaceuticaComparar+")";
                        Statement stNumProduccion=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                        System.out.println("SQL NUM PRODUCCION: "+sqlNumProduccion);
                        ResultSet rsNumProduccion=stNumProduccion.executeQuery(sqlNumProduccion);
                        
                        int numProduccion=0;
                        while(rsNumProduccion.next()){
                            numProduccion=rsNumProduccion.getInt(1);
                        }
                        String loteProduccion=loteFormaFarmaceutica+Integer.toString(loteMes)+Integer.toString(numProduccion)+loteAnio2;
                        System.out.println("FORMA FARMACEUTICA: "+loteFormaFarmaceutica);
                        System.out.println("LOTE MES: "+loteMes);
                        System.out.println("LOTE ANIO: "+loteAnio2);
                        
                        System.out.println("LOTE DE PRODUCCION:  "+loteProduccion);
                        //ACTUALIZAR EL LOTE DEL PRODUCTO
                        
                        System.out.println("bean.getFechaInicio():-- "+bean.getFechaInicio());
                        System.out.println("bean.getFechaFinal():-- "+bean.getFechaFinal());
                        
                        
                        
                        String sql="insert into programa_produccion(cod_programa_prod,cod_formula_maestra,cod_lote_produccion,fecha_inicio," ;
                        sql+=" fecha_final,cod_estado_programa,observacion,CANT_LOTE_PRODUCCION,VERSION_LOTE,COD_COMPPROD)values(";
                        sql+=" "+codProgramaPeriodo+",'"+bean.getFormulaMaestra().getCodFormulaMaestra()+"',";
                        sql+=" '"+loteProduccion+"','"+bean.getFechaInicio()+"','"+bean.getFechaFinal()+"',2,'"+bean.getObservacion()+"','1',1,"+bean.getFormulaMaestra().getComponentesProd().getCodCompprod()+")";
                        System.out.println("insert 1:"+sql);
                        Statement stUpdLote=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                        stUpdLote.executeUpdate(sql);
                        
                        sql="select ppd.COD_MATERIAL,ppd.COD_UNIDAD_MEDIDA,(ppd.CANTIDAD /pp.CANT_LOTE_PRODUCCION)";
                        sql+=" from PROGRAMA_PRODUCCION_DETALLE ppd,PROGRAMA_PRODUCCION pp";
                        sql+=" where pp.COD_PROGRAMA_PROD=ppd.COD_PROGRAMA_PROD AND";
                        sql+=" pp.COD_LOTE_PRODUCCION=ppd.COD_LOTE_PRODUCCION";
                        sql+=" and ppd.COD_COMPPROD=pp.COD_COMPPROD and pp.COD_FORMULA_MAESTRA='"+bean.getFormulaMaestra().getCodFormulaMaestra()+"'";
                        sql+=" and ppd.COD_COMPPROD="+bean.getFormulaMaestra().getComponentesProd().getCodCompprod()+" and ppd.COD_LOTE_PRODUCCION='-'";
                        Statement st_form=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                        System.out.println("SQL NUM Detalle  "+sql);
                        ResultSet rs_form=st_form.executeQuery(sql);
                        while(rs_form.next()){
                            String cod_material=rs_form.getString(1);
                            String cod_unidad_medida=rs_form.getString(2);
                            double cantidad=rs_form.getDouble(3);
                            sql=" insert into programa_produccion_detalle(cod_programa_prod,cod_material,cod_unidad_medida,cantidad," +
                                    " COD_COMPPROD,cod_lote_produccion) values(";
                            sql+=" "+codProgramaPeriodo+",'"+cod_material+"','"+cod_unidad_medida+"',"+cantidad+",";
                            sql+=" "+bean.getFormulaMaestra().getComponentesProd().getCodCompprod()+",'"+loteProduccion+"')";
                            System.out.println("insert ep:"+sql);
                            stUpdLote=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            stUpdLote.executeUpdate(sql);
                        }
                    }
                    String sqlUpdLote="delete from programa_produccion  " +
                            " where cod_programa_prod="+bean.getCodProgramaProduccion()+" " +
                            " and cod_compprod="+bean.getFormulaMaestra().getComponentesProd().getCodCompprod()+"" +
                            " and cod_lote_produccion='-'";
                    Statement stUpdLote=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    stUpdLote.executeUpdate(sqlUpdLote);
                    System.out.println("ACTUALIZA LOTE: "+sqlUpdLote);
                    
                    sqlUpdLote="delete from programa_produccion_detalle  " +
                            " where cod_programa_prod="+bean.getCodProgramaProduccion()+" " +
                            " and cod_compprod="+bean.getFormulaMaestra().getComponentesProd().getCodCompprod()+"" +
                             " and cod_lote_produccion='-'";
                    stUpdLote=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    stUpdLote.executeUpdate(sqlUpdLote);
                    System.out.println("ACTUALIZA LOTE Detalle: "+sqlUpdLote);
                }
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        %>
        <%--form method="post" action="guardar_programa_periodo.jsf" name="form1">
            <div align="center">                
                <STRONG STYLE="font-size:16px;color:#000000;">Editar Simulación de Programa de Producción</STRONG><p>
                <table border="0"  border="0" class="outputText2"  style="border:1px solid #000000"  cellspacing="0">    
                    <tr class="headerClassACliente">
                        <td  colspan="3" >
                            <div class="outputText2" align="center">
                                
                            </div>    
                        </td>
                        <td>&nbsp;&nbsp;&nbsp;</td>
                    </tr>
                    <tr><td>&nbsp;</td></tr>
                    <tr class="outputText3">                                         
                        <td>&nbsp;&nbsp;<b>Nombre</b></td>
                        <td>&nbsp;&nbsp;<b>::</b>&nbsp;&nbsp;</td>
                        <td><input type="text" id="nombrePrograma" class="inputText" style="text-transform: uppercase;" onkeypress="valMAY();" size="80" value="<%=nombrePrograma%>"></input></td>
                    </tr>
                    <tr class="outputText3">
                        <td>&nbsp;&nbsp;<b>Observación</b></td>
                        <td>&nbsp;&nbsp;<b>::</b>&nbsp;&nbsp;</td>
                        <td><textarea id="obs" cols="79" class="inputText" rows="3" ><%=obsPrograma%></textarea></td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                    </tr>
                </table>
            </div>
            <br>
            <center>
                <input type="button" class="commandButtonR"   value="Guardar" name="guardar" onclick="return mandar(form1)">
                <input type="button" class="commandButtonR"   value="Cancelar" name="calcenlar" onclick="window.history.back(1);">
            </center>
            <input type="hidden" name="nombreProgramaF">
            <input type="hidden" name="obsF">
            <input type="hidden" name="codProgramaPeriodo" value="<%=codProgramaPeriodo%>">
        </form>
        <%
        } catch (SQLException e) {
            e.printStackTrace();
        }
        --%>        
    </body>
</html>