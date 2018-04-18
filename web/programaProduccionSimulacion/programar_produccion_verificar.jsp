<%@ page import="java.sql.*" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.joda.time.*" %>
<%@ page import="com.cofar.bean.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.DecimalFormat" %>
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
    
    background-image: url('../img/003.gif');
    }
</style>
<script >
    function mandar(f){
        //alert();
        var i;
        var j=0;
        var g=0;
        cod_error=new Array();
        cod_mal=new Array();
        for(i=0;i<=f.length-1;i++)
        {
            if(f.elements[i].type=='checkbox')
            {   //alert(f.elements[i].name);
                if(f.elements[i].name=="error"){
                    if(f.elements[i].checked==true && f.elements[i+1].value==1){
                        cod_error[j]=f.elements[i].value;
                        j=j+1;
                    }
                }

                if(f.elements[i].name=="mal"){
                    if(f.elements[i].checked==true){
                        cod_mal[g]=f.elements[i].value;
                        g=g+1;
                    }
                }
            }
        }
        if(j==0 && g==0)
        {
            location.href="aprobar_programa_produccion.jsf?cod_programa_prod="+f.codProgramaProd.value;
        }
        else
        {
            //alert(cod_mal);
            //alert("../liquidacion_finiquitos/guardar_registrar_finiquito.jsf?cod_personal="+f.cod_personal.value+"&codigo="+codigo+"&fecha_calculo="+f.fecha_calculo.value+"&deducciones="+deducciones);
            location.href="aprobar_programa_produccion.jsf?cod_mal="+cod_mal+"&cod_error="+cod_error+"&cod_programa_prod="+f.codProgramaProd.value;
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
        <div align="center" class="outputText2">
        <%
        try {
            con = Util.openConnection(con);
            List<String> estadoError = new ArrayList<String>();
            List<String> estadoMal = new ArrayList<String>();
            String codProgramaProd = "";
            String codProgramaProd1 = "-1";
            String codProgramaProd2 = "-1";
            String codProgramaPeriodo = request.getParameter("codProgramaPeriodo");
            System.out.println("codProgramaPeriodo:" + codProgramaPeriodo);
            ManagedProgramaProduccionSimulacion obj = (ManagedProgramaProduccionSimulacion) Util.getSessionBean("ManagedProgramaProduccionSimulacion");
            System.out.println("codProgramaPeriodo:" + obj.getProgramaProduccionList());
            List<ProgramaProduccion> iter = obj.getProgramaProduccionList();
        /*String sqlUpdProgProd="update programa_produccion_periodo set cod_estado_programa=2 where cod_programa_prod="+codProgramaPeriodo;
        Statement stUpdProgProd=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        stUpdProgProd.executeUpdate(sqlUpdProgProd);*/
            for (ProgramaProduccion bean : iter) {
                codProgramaProd = bean.getCodProgramaProduccion();
                System.out.println("CODIGO PROGRAMA PROD: " + bean.getCodProgramaProduccion());
                System.out.println("CODIGO COMP PROD:  " + bean.getFormulaMaestra().getComponentesProd().getCodCompprod());
                System.out.println("CODIGO ESTADO SIMULACION: " + bean.getEstadoProductoSimulacion());
                String loteFormaFarmaceutica = "";
                if (bean.getEstadoProductoSimulacion() == 1 || bean.getEstadoProductoSimulacion() == 2) {
                    System.out.println("ENTRO");
                    int i = 0, j = 0;
                    if (bean.getEstadoProductoSimulacion() == 1) {
                        System.out.println("ENTRO error:::" + bean.getFormulaMaestra().getComponentesProd().getCodCompprod());
                        codProgramaProd2 = codProgramaProd2 + "," + bean.getFormulaMaestra().getComponentesProd().getCodCompprod();
                        estadoError.add(bean.getFormulaMaestra().getComponentesProd().getCodCompprod());
                    }
                    if (bean.getEstadoProductoSimulacion() == 2) {
                        System.out.println("ENTRO:::" + bean.getFormulaMaestra().getComponentesProd().getCodCompprod());
                        codProgramaProd1 = codProgramaProd1 + "," + bean.getFormulaMaestra().getComponentesProd().getCodCompprod();
                        estadoMal.add(bean.getFormulaMaestra().getComponentesProd().getCodCompprod());
                        
                    }
                    
                    /**********************************************************/
                    System.out.println("ACTUALIZA LOTE: ");
                }
                
            }
            System.out.println("codProgramaProd1: " + codProgramaProd1);
            System.out.println("codProgramaProd2: " + codProgramaProd2);
        %>
        <h3 > Productos Que Tienen Material en Tránsito</h3>
        <table border="0" class="outputText2"  style="border:1px solid #000000"  width="95%">
            <tr class="headerClassACliente">
                <td colspan="2" align="center">
                    <div class="outputText2"><b>Producto</b></div>
                </td>
                <td class="outputText2"> Lote</td>
                <td class="outputText2"> Tipo Mercadería</td>
                <td>
                    <div class="outputText2"><b>Confirmar</b></div>
                </td>
            </tr>
            <%
            // for (String c : estadoError) {
            
            
            
            
            String sql = "select cp.cod_compprod,cp.nombre_prod_semiterminado,pp.cant_lote_produccion,tp.NOMBRE_TIPO_PROGRAMA_PROD";
            sql += " from programa_produccion pp,componentes_prod cp,TIPOS_PROGRAMA_PRODUCCION tp";
            sql += " where pp.cod_estado_programa in (4) and pp.cod_programa_prod='"+codProgramaProd+"' and cp.COD_COMPPROD=pp.COD_COMPPROD";
            sql += " and cp.cod_compprod in ("+codProgramaProd2+") and tp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD ";
            sql += " order by cp.nombre_prod_semiterminado";
            
            System.out.println("sql navegador:" + sql);
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(sql);
            rs.last();
            int rows = rs.getRow();
            
            rs.first();
            String cod = "";
            for (int i = 0; i < rows; i++) {
            
            %>
            <tr>
                <td style="border:1px solid #f2f2f2"><input type="checkbox" name="error" id="error" value="<%=rs.getString(1)%>"> </td>
                <td style="border:1px solid #f2f2f2"> <%=rs.getString(2)%></td>
                <td style="border:1px solid #f2f2f2"> <%=rs.getString(3)%></td>
                <td style="border:1px solid #f2f2f2"> <%=rs.getString(4)%></td>
                <td style="border:1px solid #f2f2f2">
                    <select class="outputText2" name="mal_ckeck">
                        <option value="1">SI</option>
                        <option value="2">NO</option>
                    </select>
                </td>
            </tr>
            <%
            //System.out.print(c);
            rs.next();
            }
            // }
            %>
        </table>
        <br> <br> <br>
        
        <h3> Productos Que Tienen Material Faltante</h3>
        <table  class="outputText2"  style="border:1px solid #000000"  width="95%">
            <tr class="headerClassACliente">
                <td  align="center">
                    <div class="outputText2"><b>Material</b></div>
                </td>
                <th class="outputText2"> Lote</th>
                <th class="outputText2"> Tipo Mercadería</th>
                <th class="outputText2"> Prioridad</th>
                <td>
                    <div class="outputText2"><b>A Utilizar</b></div>
                </td>
                <td>
                    <div class="outputText2"><b>Disponible</b></div>
                </td>
                <td>
                    <div class="outputText2"><b>Tránsito</b></div>
                </td>
                <td>
                    <div class="outputText2"><b>Stock Mínimo</b></div>
                </td>
                
                
            </tr>
            <%
            String sql_m = "select e.cod_material,m.nombre_material,e.CANTIDAD_A_UTILIZAR,e.CANTIDAD_DISPONIBLE,e.cantidad_transito,m.stock_minimo_material";
            sql_m += " from EXPLOSION_MATERIALES e,materiales m";
            sql_m += " where e.CANTIDAD_A_UTILIZAR>(e.CANTIDAD_DISPONIBLE + e.CANTIDAD_TRANSITO)";
            sql_m += " and  e.cod_programa_produccion=" + codProgramaProd;
            sql_m += " and  m.cod_material=e.cod_material ORDER BY m.nombre_material";
            System.out.println("sql_m:" + sql_m);
            con = Util.openConnection(con);
            Statement st_m = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs_m = st_m.executeQuery(sql_m);
            NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
            DecimalFormat form = (DecimalFormat) nf;
            form.applyPattern("#,###.00");
            while (rs_m.next()) {
                String cod_material = rs_m.getString(1);
                String nombre_material = rs_m.getString(2);
                double cantidadUtilizar = rs_m.getDouble(3);
                double cantidadDisponible = rs_m.getDouble(4);
                double cantidadTransito = rs_m.getDouble(5);
                double stockMinimo = rs_m.getDouble(6);
            %>
            <tr bgcolor="#E3CEF6">
                <td class="outputText2"  colspan="4"> <%=nombre_material%></td>
                <td  > <%=form.format(cantidadUtilizar)%></td>
                <td class="outputText2"> <%=form.format(cantidadDisponible)%></td>
                <td class="outputText2"> <%=form.format(cantidadTransito)%></td>
                <td class="outputText2"> <%=form.format(stockMinimo)%></td>
                
            </tr>
            <%
            // for(String c:estadoMal){
            String sqlCompra = "SELECT cp.cod_compprod,p.CANT_LOTE_PRODUCCION,cp.nombre_prod_semiterminado,ppd.CANTIDAD,tp.NOMBRE_TIPO_PROGRAMA_PROD,";
            sqlCompra += " isnull((select ca.NOMBRE_CATEGORIACOMPPROD from  CATEGORIAS_COMPPROD ca WHERE ca.COD_CATEGORIACOMPPROD = cp.COD_CATEGORIACOMPPROD),'') ";            
            sqlCompra += " FROM PROGRAMA_PRODUCCION p,COMPONENTES_PROD cp,PROGRAMA_PRODUCCION_DETALLE ppd,TIPOS_PROGRAMA_PRODUCCION tp ";
            sqlCompra += " where p.COD_PROGRAMA_PROD='" + codProgramaProd + "' and p.COD_ESTADO_PROGRAMA=4 ";
            sqlCompra += " and cp.COD_COMPPROD=p.COD_COMPPROD and cp.COD_COMPPROD=ppd.COD_COMPPROD";
            sqlCompra += " and ppd.COD_COMPPROD=p.COD_COMPPROD and ppd.COD_MATERIAL='" + cod_material + "' ";
            sqlCompra += " and ppd.cod_lote_produccion=p.cod_lote_produccion and tp.COD_TIPO_PROGRAMA_PROD=p.COD_TIPO_PROGRAMA_PROD";
            sqlCompra += " and p.COD_PROGRAMA_PROD=ppd.COD_PROGRAMA_PROD";
            //System.out.println("sql compra: " + sqlCompra);
            Statement stCompra = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rsCompra = stCompra.executeQuery(sqlCompra);
            System.out.println("sqlCompra:" + sqlCompra);
            con = Util.openConnection(con);
            Statement st_e = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs_e = st_e.executeQuery(sqlCompra);
            rs_e.last();
            int rows_e = rs_e.getRow();
            
            rs_e.first();
            //String cod = "";
            for (int i = 0; i < rows_e; i++) {
                double cantidad = rs_e.getDouble(4);
            %>
            <tr>
                <td class="outputText2" style="border:1px solid #f2f2f2"> <input type="checkbox" name="mal" id="mal" value="<%=rs_e.getString(1)%>"><%=rs_e.getString(3)%></td>
                <td class="outputText2" style="border:1px solid #f2f2f2"><%=rs_e.getString(2)%></td>
                <td class="outputText2" style="border:1px solid #f2f2f2"><%=rs_e.getString(5)%></td>
                <td class="outputText2" style="border:1px solid #f2f2f2" align="center" ><%=rs_e.getString(6)%>&nbsp;</td>
                <td class="outputText2" style="border:1px solid #f2f2f2"><%=form.format(cantidad)%></td>
                <td class="outputText2" style="border:1px solid #f2f2f2">&nbsp;</td>
                <td class="outputText2" style="border:1px solid #f2f2f2">&nbsp;</td>
                <td class="outputText2" style="border:1px solid #f2f2f2">&nbsp;</td>
            </tr>
            <%
            System.out.println(rs_e.getString(3));
            rs_e.next();
            }
            // }
            }
            %>
        </table>
        <br> <br> <br>
        <input type="hidden" name="codProgramaProd" value="<%=codProgramaProd%>">
        <%
        } catch (Exception e) {
            e.printStackTrace();
        }
        %>
        
        <center>
            <input type="button" class="commandButtonR"   value="Siguiente >>" name="guardar" onclick="return mandar(form1)">
            
        </center>
        
    </form>
    </div>
</body>
</html>