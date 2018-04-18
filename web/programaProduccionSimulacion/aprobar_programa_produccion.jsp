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
                               if(f.elements[i].checked==true ){	
                                    cod_error[j]=f.elements[i].value;
                                    j=j+1;
                                }
                            }
                        }
                    }
                    if(j==0 && g==0)
                    {	//alert('Debe seleccionar almenos un Registro para ser Registrado.');
                       var aprob=f.aprobados.value;
                       //alert(f.codProgramaProd.value);
                       location.href="programar_produccion.jsf?codProgramaPeriodo="+f.codProgramaProd.value+"&cod_aprobados="+aprob+"&transito="+f.transito.value;
                 
                    }
                    else
                    {   
                        var aprob=cod_error+","+f.aprobados.value;
                        //alert(" ELSE:"+aprob);
                        location.href="programar_produccion.jsf?codProgramaPeriodo="+f.codProgramaProd.value+"&cod_aprobados="+aprob+"&transito="+f.transito.value;
                    }
                }   
                function mandar1(f){
                    alert(f.codProgramaProd.value);
                    location.href="programar_produccion.jsf?codProgramaPeriodo="+f.codProgramaProd.value;
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
        try{
            con=Util.openConnection(con);
            String mal="-1";
            String bien="-1";
            String aprobados="-1";
            List<String> estadoBien=new ArrayList<String>();
            List<String> estadoMal=new ArrayList<String>();
            String codMal=request.getParameter("cod_mal");
            String codError=request.getParameter("cod_error");
            String codProgramaProd=request.getParameter("cod_programa_prod");
            System.out.println("codProgramaProd:"+codProgramaProd);
            System.out.println("codMal:"+codMal);
            System.out.println("codError:"+codError);
            if(codError==null || codError.equals("")){
                codError="-1";
            }
            ManagedProgramaProduccionSimulacion obj=(ManagedProgramaProduccionSimulacion)Util.getSessionBean("ManagedProgramaProduccionSimulacion");
            System.out.println("codProgramaPeriodo:"+obj.getProgramaProduccionList());
            List<ProgramaProduccion> iter = obj.getProgramaProduccionList();
            /**************** ACTUALIZAMOS LOS QUE ESTAN DISPONIBLES + EN TRANSITO***************************/
            
            String sqlBorrarExplosion="delete from EXPLOSION_MATERIALES_AUXILIAR ";
            Statement stBorrarExplosion=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            System.out.println("sqlBorraExplosion: "+sqlBorrarExplosion);
            stBorrarExplosion.executeUpdate(sqlBorrarExplosion);
            String sql_inser=" insert into EXPLOSION_MATERIALES_AUXILIAR  (COD_PROGRAMA_PRODUCCION,";
            sql_inser+=" COD_MATERIAL,COD_UNIDAD_MEDIDA,CANTIDAD_DISPONIBLE,";
            sql_inser+=" CANTIDAD_TRANSITO,CANTIDAD_A_UTILIZAR)";
            sql_inser+=" select a.COD_PROGRAMA_PRODUCCION,a.COD_MATERIAL,a.COD_UNIDAD_MEDIDA,";
            sql_inser+=" a.CANTIDAD_DISPONIBLE,a.CANTIDAD_TRANSITO,a.CANTIDAD_A_UTILIZAR ";
            sql_inser+=" from EXPLOSION_MATERIALES a where a.COD_PROGRAMA_PRODUCCION='"+codProgramaProd+"'";
            Statement st_inser=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            System.out.println("sql_inser: "+sql_inser);
            st_inser.executeUpdate(sql_inser);
            if (codError != null){
                String errorVector[]=codError.split(",");
                for (int i=0;i<errorVector.length;i++){
                    String sql_error=" select pp.CANTIDAD,pp.COD_MATERIAL,ea.CANTIDAD_DISPONIBLE,ea.CANTIDAD_TRANSITO,ea.CANTIDAD_A_UTILIZAR ";
                    sql_error+=" from PROGRAMA_PRODUCCION_DETALLE pp,EXPLOSION_MATERIALES_AUXILIAR ea";
                    sql_error+=" where pp.COD_PROGRAMA_PROD='"+codProgramaProd+"' and pp.COD_COMPPROD='"+errorVector[i]+"'";
                    sql_error+=" and ea.COD_PROGRAMA_PRODUCCION=pp.COD_PROGRAMA_PROD and ea.COD_MATERIAL=pp.COD_MATERIAL";
                    System.out.println("sql_error:"+sql_error);
                    Statement st_error=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs_error=st_error.executeQuery(sql_error);
                    while(rs_error.next()){
                        double cantidad=rs_error.getDouble(1);
                        String cod_material=rs_error.getString(2);
                        double cant_disponible=rs_error.getDouble(3);
                        double cant_transito=rs_error.getDouble(4);
                        double cant_utilizar=rs_error.getDouble(5);
                        if(cantidad>cant_disponible){
                            cantidad=cantidad-cant_disponible;
                            cant_transito=cant_transito-cantidad;
                            cant_disponible=0;
                        }else{
                            cant_disponible=cant_disponible-cantidad;
                        }
                        sql_error=" update EXPLOSION_MATERIALES_AUXILIAR set ";
                        sql_error+=" CANTIDAD_DISPONIBLE="+cant_disponible+",";
                        sql_error+=" CANTIDAD_TRANSITO="+cant_transito+"";
                        sql_error+=" where cod_material='"+cod_material+"' and COD_PROGRAMA_PRODUCCION="+codProgramaProd+"";
                        System.out.println("sql_error update: "+sql_error);
                        st_inser.executeUpdate(sql_error);
                    }
                }
            }
            /****************FIN ACTUALIZAMOS LOS QUE ESTAN DISPONIBLES + EN TRANSITO***************************/
            
            
            /****************ACTUALIZAMOS LOS QUE NO SE PUEDEN PRODUCIR***************************/
            if (codMal != null && !codMal.equals("") ){
                String malVector[]=codMal.split(",");
                int sw_mal=0;
                for(int j=0;j<malVector.length;j++){
                    sw_mal=0;
                    String sql_mal="select pp.CANTIDAD,pp.COD_MATERIAL,ea.CANTIDAD_DISPONIBLE,ea.CANTIDAD_TRANSITO,ea.CANTIDAD_A_UTILIZAR ";
                    sql_mal+=" from PROGRAMA_PRODUCCION_DETALLE pp,EXPLOSION_MATERIALES_AUXILIAR ea";
                    sql_mal+=" where pp.COD_PROGRAMA_PROD='"+codProgramaProd+"' and pp.COD_COMPPROD='"+malVector[j]+"'";
                    sql_mal+=" and ea.COD_PROGRAMA_PRODUCCION=pp.COD_PROGRAMA_PROD and ea.COD_MATERIAL=pp.COD_MATERIAL";
                    sql_mal+=" and pp.CANTIDAD>(ea.CANTIDAD_DISPONIBLE)";
                    System.out.println("sql_mal:"+sql_mal);
                    Statement st_mal=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs_mal=st_mal.executeQuery(sql_mal);
                    while(rs_mal.next()){
                        sw_mal=1;
                    }
                    if(sw_mal==1){
                        mal=mal+","+malVector[j];
                    }else{
                        bien=bien+","+malVector[j];
                        sql_mal="select pp.CANTIDAD,pp.COD_MATERIAL,ea.CANTIDAD_DISPONIBLE,ea.CANTIDAD_TRANSITO,ea.CANTIDAD_A_UTILIZAR ";
                        sql_mal+=" from PROGRAMA_PRODUCCION_DETALLE pp,EXPLOSION_MATERIALES_AUXILIAR ea";
                        sql_mal+=" where pp.COD_PROGRAMA_PROD='"+codProgramaProd+"' and pp.COD_COMPPROD='"+malVector[j]+"'";
                        sql_mal+=" and ea.COD_PROGRAMA_PRODUCCION=pp.COD_PROGRAMA_PROD and ea.COD_MATERIAL=pp.COD_MATERIAL";
                        st_mal=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        rs_mal=st_mal.executeQuery(sql_mal);
                        while(rs_mal.next()){
                            double cantidad=rs_mal.getDouble(1);
                            String cod_material=rs_mal.getString(2);
                            double cant_disponible=rs_mal.getDouble(3);
                            double cant_transito=rs_mal.getDouble(4);
                            double cant_utilizar=rs_mal.getDouble(5);
                            if(cantidad>cant_disponible){
                                cantidad=cantidad-cant_disponible;
                                cant_transito=cant_transito-cantidad;
                                cant_disponible=0;
                            }else{
                                cant_disponible=cant_disponible-cantidad;
                            }
                            sql_mal=" update EXPLOSION_MATERIALES_AUXILIAR set ";
                            sql_mal+=" CANTIDAD_DISPONIBLE="+cant_disponible+",";
                            sql_mal+=" CANTIDAD_TRANSITO="+cant_transito+"";
                            sql_mal+=" where cod_material='"+cod_material+"' and COD_PROGRAMA_PRODUCCION="+codProgramaProd+"";
                            System.out.println("sql_mal update: "+sql_mal);
                            st_inser.executeUpdate(sql_mal);
                        }
                    }
                }
            }
            /**************** fin ACTUALIZAMOS LOS QUE NO SE PUEDEN PRODUCIR***************************/
            /************************* LISTAMOS A LOS APROBADOS ********************************************/
            String sql_aprob=" select  pp.COD_COMPPROD,pp.CANT_LOTE_PRODUCCION,pp.FECHA_INICIO,pp.FECHA_FINAL,pp.COD_FORMULA_MAESTRA";
            sql_aprob+=" from PROGRAMA_PRODUCCION pp";
            sql_aprob+=" where cod_programa_prod ="+codProgramaProd+"";
            System.out.println("sql_aprob:"+sql_aprob);
            Statement st_aprob=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs_aprob=st_aprob.executeQuery(sql_aprob);
            while(rs_aprob.next()){
                String codCompProd=rs_aprob.getString(1);
                String sqlEstadoProd="select em.COD_MATERIAL, em.CANTIDAD_A_UTILIZAR, em.CANTIDAD_DISPONIBLE, em.CANTIDAD_TRANSITO " ;
                sqlEstadoProd+=" from EXPLOSION_MATERIALES em where " ;
                sqlEstadoProd+=" em.cod_programa_produccion ="+codProgramaProd+" and em.cod_material " ;
                sqlEstadoProd+=" in(select p.cod_material from PROGRAMA_PRODUCCION_DETALLE p where " ;
                sqlEstadoProd+=" p.COD_COMPPROD="+codCompProd+" and p.COD_PROGRAMA_PROD="+codProgramaProd+")";
                //sqlEstadoProd+=" and ";
                System.out.println("sqlEstadoProd:"+sqlEstadoProd);
                Statement stEstadoProd=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rsEstadoProd=stEstadoProd.executeQuery(sqlEstadoProd);
                int bandera=0;
                // 0 OK; 1 CON FALTANTES; 2 NO SE PUEDE
                while(rsEstadoProd.next() && bandera==0){
                    //bean.setEstadoProductoSimulacion(1);
                    int codMaterial=rsEstadoProd.getInt(1);
                    double cantidadUtilizar=rsEstadoProd.getDouble(2);
                    double cantidadDisponible=rsEstadoProd.getDouble(3);
                    double cantidadTransito=rsEstadoProd.getDouble(4);
                    if(cantidadDisponible>=cantidadUtilizar){
                        
                        System.out.println("ENTROOOO CERO:"+aprobados);
                    }else{
                        bandera=1;
                    }
                }
                if(bandera==0){
                    aprobados=aprobados+","+codCompProd;
                }
            }
            aprobados=aprobados+","+codError+","+bien;
            System.out.println("APROBADOS********************************************:"+aprobados);
            /*********************** FIN LISTAMOS A LOS APROBADOS *******************************************/
        
        
        
        
        
        %>
        <h3 >Listado de Productos Que SI se pueden Elaborar</h3>
        <table border="0" class="outputText2"  style="border:1px solid #000000"  width="40%">
            <tr class="headerClassACliente">
                <td colspan="2" align="center">
                    <div class="outputText2"><b>Producto</b></div>
                </td>

            </tr>
            <%
            //for(String c:estadoBien){
            String sql="select c.COD_COMPPROD,c.nombre_prod_semiterminado";
            sql+=" from COMPONENTES_PROD c  where c.COD_COMPPROD in ("+bien+") and c.COD_COMPPROD <> -1";
            System.out.println("sql navegador Bien:"+sql);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            rs.last();
            int rows=rs.getRow();
            
            rs.first();
            String cod="";
            for(int i=0;i<rows;i++){
            
            %>
            <tr>
                <td style="border:1px solid #f2f2f2"><input type="checkbox" name="error" id="error" value="<%=rs.getString(1)%>"> </td>
                <td style="border:1px solid #f2f2f2"> <%=rs.getString(2)%></td>
    
            </tr>
            <%
            rs.next();
            }
            //}
            %>
        </table>
        <br> <br> <br>
        
        <h3 >Listado de Productos Que NO se pueden Elaborar</h3>
        <table border="0" class="outputText2"  style="border:1px solid #000000"  width="40%">
            <tr class="headerClassACliente">
                <td colspan="2" align="center">
                    <div class="outputText2"><b>Producto</b></div>
                </td>
       
            </tr>
            <%
            // for(String c:estadoMal){
            sql="select c.COD_COMPPROD,c.nombre_prod_semiterminado";
            sql+=" from COMPONENTES_PROD c  where c.COD_COMPPROD in ("+mal+") and c.COD_COMPPROD <> -1";
            System.out.println("sql navegador Mal:"+sql);
            st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs=st.executeQuery(sql);
            rs.last();
            rows=rs.getRow();
            
            rs.first();
            cod="";
            for(int i=0;i<rows;i++){
                System.out.println("rs.getString(2):"+rs.getString(2));
            %>
            <tr>
                <td style="border:1px solid #f2f2f2"> </td>
                <td style="border:1px solid #f2f2f2"> <%=rs.getString(2)%></td>
              
            </tr>
            <%
            rs.next();
            }
            //}
            %>
        </table>
        <br> <br> <br>
        <input type="hidden" name="codProgramaProd" value="<%=codProgramaProd%>">
        <input type="hidden" name="aprobados" value="<%=aprobados%>">
        <input type="hidden" name="transito" value="<%=codError%>">
        
        <%
        }catch(Exception e){
            e.printStackTrace();
        }
        %>
        
        <center>
            <input type="button" class="commandButtonR"   value="Siguiente >>" name="guardar" onclick="return mandar(form1);windows.close()">
            
        </center>
        
    </form>
    </div>
</body>
</html>