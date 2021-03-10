<%@ Page Title="Order Details" Language="C#" MasterPageFile="~/Member.Master" AutoEventWireup="true" CodeBehind="Order_Details.aspx.cs" Inherits="CncAgro.AccessMember.Selling.Order_Details" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3 class="mb-0">Order Details</h3>
    <a href="Order_Record.aspx"><i class="far fa-hand-point-left mr-1"></i>Back To Record</a>

    <div class="card card-body mt-3">
        <asp:FormView ID="MemberFormView" runat="server" DataSourceID="OrderInfoSQL" Width="100%" DataKeyNames="Product_DistributionID">
            <ItemTemplate>
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h4><%# Eval("Name") %></h4>
                        <p>ID: <%# Eval("UserName") %>, <%# Eval("Phone") %></p>
                    </div>

                    <div class="text-right">
                        <h5>Receipt: #<%# Eval("Distribution_SN") %></h5>
                        <p>Order Date:<%# Eval("InsertDate","{0:d MMM yyyy}") %></p>
                    </div>
                </div>
            </ItemTemplate>
        </asp:FormView>
        <asp:SqlDataSource ID="OrderInfoSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Registration.Name, Registration.UserName, Registration.Phone, Registration_1.Name AS ServedBy, Product_Distribution.Product_Total_Amount, Product_Distribution.Distribution_SN, Product_Distribution.Is_Confirmed, Product_Distribution.Is_Delivered, Product_Distribution.Delivery_Date, Product_Distribution.Confirm_Date, Product_Distribution.InsertDate, Product_Distribution.MemberID, Product_Distribution.Product_DistributionID FROM Product_Distribution INNER JOIN Registration INNER JOIN Member ON Registration.RegistrationID = Member.MemberRegistrationID ON Product_Distribution.MemberID = Member.MemberID LEFT OUTER JOIN Registration AS Registration_1 ON Product_Distribution.Admin_RegistrationID = Registration_1.RegistrationID WHERE (Product_Distribution.Product_DistributionID = @Product_DistributionID)">
            <SelectParameters>
                <asp:QueryStringParameter Name="Product_DistributionID" QueryStringField="id" />
            </SelectParameters>
        </asp:SqlDataSource>

        <div class="table-responsive">
            <asp:GridView ID="DetailsGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataSourceID="DetailsSQL">
                <Columns>
                    <asp:BoundField DataField="Product_Code" HeaderText="Code" SortExpression="Product_Code" />
                    <asp:BoundField DataField="Product_Name" HeaderText="Product Name" SortExpression="Product_Name" />
                    <asp:BoundField DataField="SellingQuantity" HeaderText="Quantity" SortExpression="SellingQuantity" />
                    <asp:BoundField DataField="SellingUnitPrice" HeaderText="Unit Price" SortExpression="SellingUnitPrice" />
                    <asp:BoundField DataField="ProductPrice" HeaderText="Line Total" ReadOnly="True" SortExpression="ProductPrice" />
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="DetailsSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Product_Point_Code.Product_Code, Product_Point_Code.Product_Name, Product_Distribution_Records.SellingQuantity, Product_Distribution_Records.SellingUnitPrice, Product_Distribution_Records.SellingUnitPoint, Product_Distribution_Records.ProductPrice, Product_Distribution_Records.TotalPoint FROM Product_Distribution_Records INNER JOIN Product_Point_Code ON Product_Distribution_Records.ProductID = Product_Point_Code.Product_PointID WHERE (Product_Distribution_Records.Product_DistributionID = @Product_DistributionID)">
                <SelectParameters>
                    <asp:QueryStringParameter Name="Product_DistributionID" QueryStringField="id" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>

            <asp:FormView ID="GrandTotalFormView" runat="server" DataSourceID="OrderInfoSQL" Width="100%" DataKeyNames="Product_DistributionID">
                <ItemTemplate>
                    <h4 class="text-right">Grand Total: <%# Eval("Product_Total_Amount") %></h4>
                </ItemTemplate>
            </asp:FormView>
        </div>
    </div>
</asp:Content>
