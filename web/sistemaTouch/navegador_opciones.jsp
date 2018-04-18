<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="reponse/css/foundation.css" />
            <link rel="STYLESHEET" type="text/css" href="reponse/css/AtlasWeb.css" />
            <script type="text/javascript" src='../js/general.js' ></script> 
            <script>
                function validar(){                
                    return true;
                }
                function checkKey(key)
                {
                        var unicode
                        if (key.charCode)
                        {
                            unicode=key.charCode;
                        }
                        else
                        {
                            unicode=key.keyCode;
                        }
                        if (unicode == 13)
                        {
                            document.getElementById('form1:aceptar').click();
                        }

                }
                function openPopup(url){
                    var a=Math.random();
                    var name="registro touch"+Math.random();
                    window.open(url+'&a='+a,name,'top=50,left=200,width=800,height=500,scrollbars=1,resizable=1');
                }
                function verReporteTiempos(codArea)
                {
                    var fecha=new Date();
                    var url='reporteTiempoPersonal/filtroReporteTiemposPersonal.jsf?ab='+Math.random()+'&codArea='+codArea+
                        '&codPersonal='+document.getElementById("codPersonal").value+"&d="+fecha.getTime().toString();
                    openPopup(url);
                }
                function navegadorComprimidos()
                {
                    window.location.href=encodeURI('registroSeguimientoTabletaComprimidos/navProgProdProcesos.jsf?a='+Math.random()+
                        '&d='+((new Date()).getTime().toString())+'&p='+document.getElementById("codPersonal").value+
                        '&codAreaEmpresa='+document.getElementById("codAreaEmpresa").value);
                }
                function navegadorInyectable()
                {
                    window.location.href=encodeURI('registroSeguimientoTableta/navProgProdProcesos.jsf?a='+Math.random()+
                        "&d="+((new Date()).getTime().toString())+"&p="+document.getElementById("codPersonal").value);
                }
                function navegadorOMAcondicionamiento(codAreaEmpresa,codPersonal)
                {
                    window.location.href=encodeURI('OmAcondicionamiento/navProgProduccion.jsf?a='+Math.random()+'&codAreaEmpresa='+codAreaEmpresa+
                        "&d="+((new Date()).getTime().toString())+"&p="+codPersonal);
                }
            </script>
        </head>
        <body>
            <form>
                <%
                String codPersonal="0";
                String codAreaEmpresa="";
                if(session.getAttribute("codAreaEmpresa")==null||session.getAttribute("codPersonal")==null)
                {
                    
                    response.sendRedirect("login.jsf");
                    
                }
                else
                    {
                codPersonal=(String)session.getAttribute("codPersonal");
                codAreaEmpresa=(String)session.getAttribute("codAreaEmpresa");
                
                
                %>
                <section class="main" style="margin-top:5%">
                     <div class="large-4 medium-5 small-6 large-centered medium-centered small-centered columns" >

                        <div class="row">
                           <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                   <label  class="inline">Modulos</label>
                            </div>
                        </div>
                        <div class="row">
                        <div  class="divContentClass large-12 medium-12 small-12 columns ">
                                <div class="row" style="margin-top:5%;margin-bottom:5%">
                                    <div class="large-12 medium-12 small-12 columns large-centered medium-centered small-centered">
                                         <%
                                         if(codAreaEmpresa.equals("81")||codAreaEmpresa.equals("80"))
                                         {
                                              %>
                                              <div class="row" >
                                                  <div class="large-1 medium-1 small-1 columns">&nbsp;</div>
                                                  <div class="large-9 medium-9 small-9 columns divMenuItem"
                                                  onclick="navegadorInyectable();">
                                                        <label>OM PREPARADO INYECTABLES/OFTALMICOS</label>
                                                    </div>
                                                    <div class="large-2 medium-2 small-2 columns ">
                                                        <div class="divMenuItem" style="width:2.3em;height:2.3em"
                                                        onclick="verReporteTiempos('81')">
                                                        <img src="../img/reporteOM.gif">
                                                        </div>
                                                    </div>
                                              </div>
                                            
                                              
                                           <%
                                           }
                                           if(codAreaEmpresa.equals("82")||codAreaEmpresa.equals("40"))
                                            {
                                               %>
                                              <div class="row" >
                                                  <div class="large-1 medium-1 small-1 columns">&nbsp;</div>
                                                  <div class="large-9 medium-9 small-9 columns divMenuItem"
                                                  onclick="navegadorComprimidos();">
                                                        <label>OM PREPARADO COMPRIMIDOS</label>
                                                  </div>
                                                  <div class="large-2 medium-2 small-2 columns">
                                                      <div class="divMenuItem" style="width:2.3em;height:2.3em"
                                                        >
                                                            <img src="../img/reporteOM.gif">
                                                      </div>
                                                    </div>
                                              </div>
                                          <%
                                          }
                                          if(codAreaEmpresa.equals("102")||codAreaEmpresa.equals("84"))
                                          {
                                                out.println("<script>navegadorOMAcondicionamiento('"+codAreaEmpresa+"','"+codPersonal+"');</script>");
                                          
                                              }
                                              %>
                                              
                                    </div>
                                </div>
                         </div>
                         </div>
                     </div>
                
                </section>
                <%
                }
                %>
                <input type="hidden" id="codPersonal" value="<%=(codPersonal)%>">
                    <input type="hidden" id="codAreaEmpresa" value="<%=(codAreaEmpresa)%>">
            </form>

        </body>
    </html>
</f:view>


