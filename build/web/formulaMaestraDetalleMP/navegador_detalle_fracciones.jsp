<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>

    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src="../js/general.js" ></script>
            <script type="text/javascript">
                /*FUNCION DE VALIDACION*/
                function validar(nametable){
                   var cantidadTotal=document.getElementById('form1:cantidadTotal');                   
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   var sumaTotal=0;
                   for(var i=1;i<rowsElement.length;i++){
                        var cellsElement=rowsElement[i].cells;
                        var cel1=cellsElement[1];
                        var data1=cel1.getElementsByTagName('input')[0].value;
                        sumaTotal=parseFloat(sumaTotal)+parseFloat(data1);
                   }
                   //alert(parseFloat(cantidadTotal.innerHTML) + " " + Math.round(parseFloat(sumaTotal)*100)/100);
                   sumaTotal = (Math.round(parseFloat(sumaTotal)*100)/100);
                   if(parseFloat(cantidadTotal.innerHTML)!=parseFloat(sumaTotal)){
                       alert("La suma de las cantidades es diferente a la CANTIDAD TOTAL.");
                       return false;
                   }
                   return true;
                }
            </script>
        </head>
        <body>
            <h:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedFormulaMaestraDetalleMP.obtenerCodigoFracciones}"   />
                </div>
                <div align="center">
                    <b>Materia Prima de : </b><h:outputText value="#{ManagedFormulaMaestraDetalleMP.formulaMaestraDetalleMPbean.materiales.nombreMaterial}"   /><br><br>
                    <b>Cantidad Total: </b><h:outputText value="#{ManagedFormulaMaestraDetalleMP.formulaMaestraDetalleMPbean.cantidad}" id="cantidadTotal"/><br><br>

                    <rich:dataTable value="#{ManagedFormulaMaestraDetalleMP.fraccionesDetalleMPList}" var="data" id="detalleFracciones"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';"
                                    headerClass="headerClassACliente">
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                            </f:facet>
                            <h:outputText value="#{data.rows}" />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Cantidades"  />
                            </f:facet>
                            <h:inputText value="#{data.cantidad}" style="align-text:left;" styleClass="inputText"  onkeypress="valNum();"/>
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Tipo Material Produccion"  />
                            </f:facet>
                            <h:selectOneMenu value="#{data.tiposMaterialProduccion.codTipoMaterialProduccion}" styleClass="inputText">
                                <f:selectItems value="#{data.tiposMaterialProduccionList}" />
                            </h:selectOneMenu>
                        </h:column>
                    </rich:dataTable>

                    <br>
                    <h:commandButton value="Guardar"   styleClass="btn"  action="#{ManagedFormulaMaestraDetalleMP.guardarFormulaMaestraDetalleMPfracciones}" onclick="return validar('form1:detalleFracciones');"/>
                    <h:commandButton value="Cancelar" styleClass="btn"  action="navegadorFormulaMaestraDetalleMP" />


                </div>

                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedFormulaMaestraDetalleMP.closeConnection}"  />

            </h:form>

        </body>
    </html>

</f:view>

