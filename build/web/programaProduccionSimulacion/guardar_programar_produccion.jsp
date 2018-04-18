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
                   alert();
                    var i;
                    var j=0;       
                    var g=0; 
                    cod_error=new Array();
                    cod_mal=new Array();
                    for(i=0;i<=f.length-1;i++)
                    {
                	if(f.elements[i].type=='checkbox')
                        {   //alert(f.elements[i].name);
                            if(f.elements[i].name=="lote_prod"){
                               if(f.elements[i].checked==true && f.elements[i+1].value==1){	
                                    cod_error[j]=f.elements[i].value;
                                    j=j+1;
                                }
                            }
                        }
                    }
                    if(j==0 && g==0)
                    {	//alert('Debe seleccionar almenos un Registro para ser Registrado.');
                       var aprob=f.aprobados.value;
                       alert(f.codProgramaProd.value);
                       location.href="programar_produccion.jsf?codProgramaPeriodo="+f.codProgramaProd.value+"&cod_aprobados="+aprob;
                       window.close();
                    }
                    else
                    {   
                        var aprob=f.aprobados.value+cod_error;
                        alert(aprob);
                        location.href="programar_produccion.jsf?codProgramaPeriodo="+f.codProgramaProd.value+"&cod_aprobados="+aprob;
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
        int result=0;
        String codProgramaPeriodo=request.getParameter("codProgramaPeriodo");
        String codLotesAnterior=request.getParameter("cod_lotes_anterior");
        String codCompProd=request.getParameter("cod_comp_prod");
        
        
        System.out.println("codLotesAnterior:"+codLotesAnterior);
        System.out.println("codCompProd:"+codCompProd);
        System.out.println("codProgramaPeriodo================>>>>>"+codProgramaPeriodo);
        
        
        String codLotesAnteriorVector[]=codLotesAnterior.split(",");
        String codCompProdVector[]=codCompProd.split(",");
        for(int i=1;i<codLotesAnteriorVector.length;i++){
            String sql="update PROGRAMA_PRODUCCION_DETALLE set " ;
            sql+=" cod_lote_produccion='"+codCompProdVector[(i*2)-1]+"'" ;
            sql+=" where COD_PROGRAMA_PROD='"+codProgramaPeriodo+"' " ;
            sql+=" and COD_COMPPROD="+codCompProdVector[(i-1)*2];
            sql+=" and cod_lote_produccion='"+codLotesAnteriorVector[i]+"'";
            System.out.println("PROGRAMA_PRODUCCION_DETALLE:sql:"+sql);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            result=result+st.executeUpdate(sql);
            
            sql="update PROGRAMA_PRODUCCION  set " ;
            sql+=" cod_lote_produccion='"+codCompProdVector[(i*2)-1]+"'" ;
            sql+=" where COD_PROGRAMA_PROD='"+codProgramaPeriodo+"' " ;
            sql+=" and COD_COMPPROD="+codCompProdVector[(i-1)*2];
            sql+=" and cod_lote_produccion='"+codLotesAnteriorVector[i]+"'";
            System.out.println("PROGRAMA_PRODUCCION:sql:"+sql);
            st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            result=result+st.executeUpdate(sql);
        }
        
    }catch(Exception e){
        e.printStackTrace();
    }
    %>
    
    </div>
    
</body>
</html>