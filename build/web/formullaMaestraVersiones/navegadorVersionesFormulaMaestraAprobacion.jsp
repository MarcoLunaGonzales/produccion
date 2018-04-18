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
            <style>
                .subCabecera
                {
                    background-color:#9d5a9e;
                    color:white;
                    font-weight:bold;
                }
                .headerLocal{
                    background-image:none;
                    background-color:#9d5f9f;
                    font-weight:bold;
                }
                .celdaVersion{
                    background-color:#eeeeee;
                }
            </style>
            <script>
                function editarVersion()
                {
                    var tabla=document.getElementById("form1:dataFormula");
                    var cont=0;
                    for(var i=0;i<tabla.rows.length;i++)
                    {
                        if((tabla.rows[i].cells[0].getElementsByTagName("input").length>0)&&tabla.rows[i].cells[0].getElementsByTagName("input").checked)
                        {
                            cont++;
                        }
                    }
                    if(cont==0)
                    {
                        alert('Debe seleccionar al menos un registro');
                        return false;
                    }
                    if(cont>1)
                    {
                        alert('No puede seleccionar mas de un registro');
                        return false;
                    }
                    return true;
                }
                function editarItem(nametable){
                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=2;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel.getElementsByTagName('input')[0].checked){
                           count++;
                         }

                     }

                   }
                   if(count==1){
                      return true;
                   } else if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                   }
                   else if(count>1){
                       alert('Solo puede escoger un registro');
                       return false;
                   }
                }
    </script>
        </head>
        <body>
            <h:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedVersionesFormulaMaestra.cargarFormulaMaestraEnAprobacion}"   />
                    <h:outputText styleClass="outputText2" style="font-weight:bold;font-size:14px;"  value="Listado de Versiones de Formula Maestra En Aprobacion" />

                    <rich:dataTable value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionAprobarList}" var="data" id="dataFormula"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerLocal"  style="margin-top:8px;"
                                    >
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column rowspan="2">
                                    <h:outputText value=""/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Fecha Creación"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Personal Creacion"  />
                                </rich:column>
                                <rich:column colspan="4">
                                    <h:outputText value="Tipo Modificacion"  />
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Producto"  />
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Tipo Produccion"  />
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Persona(s) Modificación"  />
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Estado Formula"  />
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Nro Version"  />
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Cantidad Lote"  />
                                </rich:column>
                                <rich:column  breakBefore="true">
                                    <h:outputText value="NF"  />
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="MP y EP"  />
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="ES"  />
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="R"  />
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        <rich:subTable var="subData" value="#{data.formulaMaestraVersionModificacionList}" rowKeyVar="rowkey">
                                <rich:column   rowspan="#{data.formulaMaestraVersionModificacionLength}"  rendered="#{rowkey eq 0}" >
                                    <h:selectBooleanCheckbox value="#{data.checked}"  />
                                </rich:column>
                                <rich:column   rowspan="#{data.formulaMaestraVersionModificacionLength}"  rendered="#{rowkey eq 0}" >
                                    <h:outputText value="#{data.fechaModificacion}"  title="Fecha Creacion">
                                        <f:convertDateTime pattern="dd/MM/yyyy HH:mm" />
                                    </h:outputText>
                                </rich:column>
                                <rich:column   rowspan="#{data.formulaMaestraVersionModificacionLength}"  rendered="#{rowkey eq 0}" >
                                    <h:outputText value="#{data.personalCreacion.nombrePersonal}" styleClass="outputText2"/>
                                </rich:column>
                                 <rich:column  rowspan="#{data.formulaMaestraVersionModificacionLength}"  rendered="#{rowkey eq 0}">
                                    <h:outputText value="X" rendered="#{data.modificacionNF}" />
                                </rich:column>
                            <rich:column  rowspan="#{data.formulaMaestraVersionModificacionLength}"  rendered="#{rowkey eq 0}">
                                    <h:outputText value="X" rendered="#{data.modificacionMPEP}" />
                                </rich:column>
                                <rich:column  rowspan="#{data.formulaMaestraVersionModificacionLength}"  rendered="#{rowkey eq 0}">
                                    <h:outputText value="X" rendered="#{data.modificacionES}" />
                                </rich:column>
                                <rich:column  rowspan="#{data.formulaMaestraVersionModificacionLength}"  rendered="#{rowkey eq 0}">
                                    <h:outputText value="X" rendered="#{data.modificacionR}" />
                                </rich:column>
                                <rich:column   rowspan="#{data.formulaMaestraVersionModificacionLength}"  rendered="#{rowkey eq 0}" >
                                    <h:outputText value="#{data.componentesProd.nombreProdSemiterminado}"  />
                                </rich:column>
                                <rich:column   rowspan="#{data.formulaMaestraVersionModificacionLength}"  rendered="#{rowkey eq 0}" >
                                    <h:outputText value="#{data.componentesProd.tipoProduccion.nombreTipoProduccion}" styleClass="outputText2"/>
                                </rich:column>
                                <rich:column styleClass="celdaVersion">
                                        <h:outputText value="#{subData.personal.nombrePersonal}"/>
                                        <h:inputHidden value="#{subData.personal.codPersonal}"/>
                           </rich:column >
                                <rich:column   rowspan="#{data.formulaMaestraVersionModificacionLength}"  rendered="#{rowkey eq 0}" >
                                    <h:outputText value="#{data.estadoRegistro.nombreEstadoRegistro}" styleClass="outputText2"/>
                                </rich:column>
                                <rich:column   rowspan="#{data.formulaMaestraVersionModificacionLength}"  rendered="#{rowkey eq 0}" >
                                    <h:outputText value="#{data.nroVersion}"  title="Cantidad Lote" />
                                </rich:column>
                                <rich:column   rowspan="#{data.formulaMaestraVersionModificacionLength}"  rendered="#{rowkey eq 0}" >
                                    <h:outputText value="#{data.cantidadLote}"  title="Cantidad Lote" />
                                </rich:column>
                         </rich:subTable>


                    </rich:dataTable>
                <div align="center" style="margin-top:12px">
                    <a4j:commandButton value="Revisar Version"
                    onclick="if(!editarItem('form1:dataFormula')){return false;}"
                    action="#{ManagedVersionesFormulaMaestra.revisarVersionFormulaMaestra_action}" styleClass="btn"
                    oncomplete="var a =Math.random();window.location.href='navegadorRevisarFormulaMaestra.jsf?a='+a"
                    reRender="dataFormula"/>
                </div>
                </div>
            </h:form>

        </body>
    </html>

</f:view>

