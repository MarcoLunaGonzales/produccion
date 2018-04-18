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
            <script>
                       

   function nuevoAjax()
    {	var xmlhttp=false;
                try {
                        xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
                    } catch (e) {
                    try {
 			xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
                    } catch (E) {
                        	xmlhttp = false;
                    }                    
                    }
                    if (!xmlhttp && typeof XMLHttpRequest!="undefined") {
                       xmlhttp = new XMLHttpRequest();
                    }
                    return xmlhttp;
     }
     
   
    function verificarCantidad()
    {
        var cantidadReg=0;
        var valoresTabla=document.getElementById('form1:dataProgramaProduccionEditar');
        var cantidadLote=parseFloat(document.getElementById('form1:cantidadLote').innerHTML);
        
            for(var j=1;j<valoresTabla.rows.length;j++)
            {
                 if(!(parseFloat(valoresTabla.rows[j].cells[2].getElementsByTagName('input')[0].value)>0))
                        {
                            alert('La cantidad de lote debe ser mayor a cero en la fila '+j);
                            return false;
                        }
                cantidadReg+=parseFloat(valoresTabla.rows[j].cells[2].getElementsByTagName('input')[0].value);
            }
            if(cantidadReg<cantidadLote)
            {
               alert('No se puede registrar esta cantidad porque es menor a la cantidad del lote')
               return false;
            }
            if(cantidadReg>cantidadLote)
            {
                alert('No se puede registrar esta cantidad porque sobrepasa a la cantidad del lote')
                return false;

            }
        return true;
        
    }
    function repetirLote(celda)
    {
        var valoresTabla=document.getElementById('form1:dataProgramaProduccionEditar');
        for(var j=1;j<valoresTabla.rows.length;j++)
        {
            //inicio ale ultimo
            valoresTabla.rows[j].cells[3].getElementsByTagName('input')[0].value=celda.value;
            //final ale ultimo
        }
    }
    //inicio ale ultimo
    function verificar()
    {
        if(verificarCantidad())
            {
        if(confirm('Esta seguro de guardar esta información?')==true)
        {


            var valoresTabla=document.getElementById('form1:dataProgramaProduccionEditar');
            
           for(var i=1;i<valoresTabla.rows.length;i++)
           {

               if(valoresTabla.rows[i].cells[4].getElementsByTagName('input')[0].value=='')
                  {
                      alert('No puede registrar el Nro de lote ');
                      return false;
                  }
               if(parseInt(valoresTabla.rows[i].cells[1].getElementsByTagName('SELECT').length)!=0)
                   {
                       if(parseInt(valoresTabla.rows[i].cells[1].getElementsByTagName('SELECT')[0].value)==0)
                       {
                           alert('Tiene que seleccionar el producto en la fila '+i);
                           return false;
                       }
                   }
               if(parseInt(valoresTabla.rows[i].cells[3].getElementsByTagName('SELECT')[0].value)==0)
                   {
                       alert('Tiene que seleccionar el tipo de programa produccion en la fila '+i);
                       return false;
                   }
                for(var j=1;j<valoresTabla.rows.length;j++)
                   {
                       if(i!=j)
                           {
                              /* if(((valoresTabla.rows[i].cells[0].getElementsByTagName('SELECT')[0]==null?'0':valoresTabla.rows[i].cells[0].getElementsByTagName('SELECT')[0].value)==(valoresTabla.rows[j].cells[0].getElementsByTagName('SELECT')[0]==null?'0':valoresTabla.rows[j].cells[0].getElementsByTagName('SELECT')[0].value))&&
                                  (valoresTabla.rows[i].cells[2].getElementsByTagName('SELECT')[0].value==valoresTabla.rows[j].cells[2].getElementsByTagName('SELECT')[0].value)&&
                                  (valoresTabla.rows[i].cells[3].getElementsByTagName('input')[0].value==valoresTabla.rows[j].cells[3].getElementsByTagName('input')[0].value))
                              */
                             if(((valoresTabla.rows[i].cells[1].getElementsByTagName('SELECT')[0]==null?'0':valoresTabla.rows[i].cells[1].getElementsByTagName('SELECT')[0].value)==(valoresTabla.rows[j].cells[1].getElementsByTagName('SELECT')[0]==null?'0':valoresTabla.rows[j].cells[1].getElementsByTagName('SELECT')[0].value))&&
                                  (valoresTabla.rows[i].cells[3].getElementsByTagName('SELECT')[0].value==valoresTabla.rows[j].cells[3].getElementsByTagName('SELECT')[0].value)&&
                                  (valoresTabla.rows[i].cells[4].getElementsByTagName('input')[0].value==valoresTabla.rows[j].cells[4].getElementsByTagName('input')[0].value))
                                  {
                                    alert('No puede registrar datos duplicados')
                                    return false;
                                  }


                           }
                   }

           }
           return true;
        }
        else
      {return false;}
      }
      else
          {return false;}
      return false;

    }
    function validarTamano()
    {
        var valoresTabla=document.getElementById('form1:dataProgramaProduccionEditar');
        var cont=1;
        for(var i=1;i<valoresTabla.rows.length;i++)
            {
                if(valoresTabla.rows[i].cells[0].getElementsByTagName('input').checked==true)
                  {
                      cont++;
                  }
            }
        if(cont<valoresTabla.rows.length)
            {
                return true;
            }
            else
                {
                    alert('No se puede eliminar todos los registros');
                    return false;
                }
        return true;
    }

    function valEnteros()
            {
              if ((event.keyCode < 48 || event.keyCode > 57) )
                 {
                    alert('Introduzca solo Numeros Enteros');
                    event.returnValue = false;
                 }
            }
    //final ale ultimo
    
    //final ale edicion
      </script>
        </head>
        
        <body >
            <a4j:form id="form1">
                <div align="center">
                    
                    <a4j:jsFunction name="masAction" id="masAction" action="#{ManagedProgramaProduccionDesarrollo.mas_Action}" reRender="dataProgramaProduccionEditar"/>
                    <h:outputText styleClass="outputTextTitulo"  value="Programas de Producción" />                    
                    <br><br>
                   <h:outputText styleClass="outputTextTitulo"value="Producto Inicial: " /><h:outputText styleClass="outputTextTitulo"  value="#{ManagedProgramaProduccionDesarrollo.programaProduccionEditar.formulaMaestra.componentesProd.nombreProdSemiterminado}" />
                   <br><h:outputText styleClass="outputTextTitulo"value="Tipo Programa Producción: " /><h:outputText styleClass="outputTextTitulo" value="#{ManagedProgramaProduccionDesarrollo.programaProduccionEditar.tiposProgramaProduccion.nombreProgramaProd}" />
                   <br><h:outputText styleClass="outputTextTitulo"value="Cantidad Lote Inicial: " /><h:outputText styleClass="outputTextTitulo" id="cantidadLote" value="#{ManagedProgramaProduccionDesarrollo.programaProduccionEditar.cantidadLote}" />
                   <br><h:outputText styleClass="outputTextTitulo"value="Nro Lote Inicial: " /><h:outputText styleClass="outputTextTitulo"  value="#{ManagedProgramaProduccionDesarrollo.programaProduccionEditar.codLoteProduccion}" />
                   
                    <br> <br>

                    <rich:dataTable value="#{ManagedProgramaProduccionDesarrollo.programaProduccionEditarList}" var="data" id="dataProgramaProduccionEditar"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    binding="#{ManagedProgramaProduccionDesarrollo.programaProduccionEditarDataTable}"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                                    headerClass="headerClassACliente" >
                       <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"/>
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Producto"  />
                            </f:facet>
                           
                           <h:selectOneMenu value="#{data.formulaMaestra.componentesProd.codCompprod}" styleClass="inputText2">
                               <f:selectItems value="#{data.productosList}"/>
                               <a4j:support event="onchange" action="#{ManagedProgramaProduccionDesarrollo.productoEditar_change}" />
                            </h:selectOneMenu>
                        </h:column>
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Cantidad del Lote a Producir"  />
                            </f:facet>
                            <h:inputText value="#{data.cantidadLote}" styleClass="inputText2" onkeypress="valEnteros()"/>
                             
                        </h:column>
                        
                         <h:column>
                            <f:facet name="header">
                                <h:outputText value="Tipo Programa Produccion"  />
                            </f:facet>
                            <h:selectOneMenu value="#{data.tiposProgramaProduccion.codTipoProgramaProd}" styleClass="inputText2">
                                <f:selectItems value="#{ManagedProgramaProduccionDesarrollo.tiposProgramaProdList}"/>
                                
                                <a4j:support event="onchange" action="#{ManagedProgramaProduccionDesarrollo.tipoProgramaProduccionEditar_change}" reRender="dataProgramaProduccionEditar" />
                                
                            </h:selectOneMenu>
                        </h:column>
                        <%--final ale ultimo--%>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Nro de Lote"  />
                            </f:facet>
                            <h:inputText styleClass="inputText" size="12" value="#{data.codLoteProduccion}" onkeyup="repetirLote(this)" />
                        </h:column>   
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Fecha Inicio"  />
                            </f:facet>
                            <h:outputText value="#{data.fechaInicio}"  />
                        </h:column>  
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Fecha Final"  />
                            </f:facet>
                            <h:outputText value="#{data.fechaFinal}"  />
                        </h:column> 
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Observaciones"  />
                            </f:facet>
                            <%--inicio ale edicion--%>
                            <h:inputText value="#{data.observacion}" styleClass="inputText2"/>
                            <%--final ale edicion--%>
                        </h:column>
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoProgramaProduccion.nombreEstadoProgramaProd}" />
                        </h:column>
                 
                    </rich:dataTable>
                    <center>
                        <a4j:commandLink  action="#{ManagedProgramaProduccionDesarrollo.mas_Action}" reRender="dataProgramaProduccionEditar" >
                            <h:graphicImage url="../img/mas.png"/>
                        </a4j:commandLink>
                        <a4j:commandLink action="#{ManagedProgramaProduccionDesarrollo.menos_Action}" reRender="dataProgramaProduccionEditar" >
                            <h:graphicImage url="../img/menos.png"/>
                        </a4j:commandLink>
                        </center>
                    <br>
                        <a4j:jsFunction action="#{ManagedProgramaProduccionDesarrollo.terminarRegistro_Action}" name="retornar"/>
                    <a4j:commandButton value="Guardar"   styleClass="btn"  action="#{ManagedProgramaProduccionDesarrollo.guardarLotes}" onclick="if(verificar()==false){return false;}" oncomplete="if('#{ManagedProgramaProduccionDesarrollo.mensaje}'!=''){alert('#{ManagedProgramaProduccionDesarrollo.mensaje}');}else{alert('se registro la edición del lote');retornar();}"/>
                    
                    <h:commandButton value="Cancelar"    styleClass="btn"  action="#{ManagedProgramaProduccionDesarrollo.cancelar}" />
               
               
                </div>
                
                
            </a4j:form>

                    <a4j:status id="statusPeticion"
                                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
                     </a4j:status>

                    <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                                     minWidth="200" height="80" width="400" zindex="100" onshow="window.focus();">

                        <div align="center">
                            <h:graphicImage value="../img/load2.gif" />
                        </div>
                    </rich:modalPanel>
        </body>
    </html>
    
</f:view>

