<%@ Page Title="My Alliance Details" Language="C#" MasterPageFile="~/Member.Master" AutoEventWireup="true" CodeBehind="MyAlliance_Details.aspx.cs" Inherits="CncAgro.AccessMember.MyAlliance_Details" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/Member_Profile.css" rel="stylesheet" />
    <style>
        .Comission { text-transform: uppercase; box-shadow: 0 2px 5px 0 rgba(0,0,0,.16),0 2px 10px 0 rgba(0,0,0,.12); background-color: #4285F4; color: #fff; padding: 27px 3px; margin-bottom: 19px; text-align: center; }
        .Info { margin-bottom: 0; }
            .Info img { height: 120px; width: 100px; border: 1px solid #ddd; }
        .infowrap { float: left; }
            .infowrap:first-child { margin-right: 15px; }

        @media (max-width: 768px) {
            .Info img { margin: auto; display: block; }
            .infowrap { float: none; text-align: center; }
                .infowrap:first-child { margin-right: 0; }
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div class="card Member-info">
        <asp:FormView ID="MemberFormView" runat="server" DataKeyNames="RegistrationID" DataSourceID="MemberSQL" Width="100%">
            <ItemTemplate>
                <div class="Info">
                    <div class="infowrap">
                        <img src="/Handler/UserPhoto.ashx?id=<%#Eval("RegistrationID") %>" class="img-thumbnail img-responsive" />
                    </div>
                    <div class="infowrap">
                        <ul>
                            <li>
                                <i class="glyphicon glyphicon-user rest-userico"></i>
                                <b>Name:</b>
                                <asp:Label ID="Label2" runat="server" Text='<%# Bind("Name") %>' />
                            </li>
                            <li>
                                <span class="glyphicon glyphicon-earphone"></span>
                                <b>Mobile:</b>
                                <asp:Label ID="PhoneLabel1" runat="server" Text='<%# Bind("Phone") %>' />
                            </li>
                            <li>
                                <i class="glyphicon glyphicon-user rest-userico"></i>
                                <b>Referral ID:</b>
                                <asp:Label ID="Label1" runat="server" Text='<%# Bind("Refarel_UserName") %>' />
                            </li>
                            <li>
                                <i class="glyphicon glyphicon-calendar"></i>
                                <b>Signup Date:</b>
                                <asp:Label ID="SignUpDateLabel" runat="server" Text='<%# Bind("SignUpDate","{0:d MMMM yyyy}") %>' />
                            </li>
                        </ul>
                    </div>
                </div>
            </ItemTemplate>
        </asp:FormView>
        <asp:SqlDataSource ID="MemberSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Registration.Name, Registration.Email, Member.MemberID, Member.SignUpDate, Registration.RegistrationID, Refarel_Registration.UserName AS Refarel_UserName, Registration.Phone FROM Registration AS Refarel_Registration INNER JOIN Member AS Refarel_Member ON Refarel_Registration.RegistrationID = Refarel_Member.MemberRegistrationID RIGHT OUTER JOIN Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID ON Refarel_Member.MemberID = Member.Referral_MemberID WHERE (Member.MemberID = @MemberID)">
            <SelectParameters>
                <asp:QueryStringParameter Name="MemberID" QueryStringField="Member" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>

    <asp:FormView ID="BonusFormView" runat="server" DataSourceID="BonusSQL" Width="100%">
        <ItemTemplate>
            <h3><strong style="color: #4285F4">Balance: ৳<%#Eval("Available_Balance","{0:N}") %></strong></h3>
            <div class="row">
                <div class="col-sm-4">
                    <div class="Comission">
                        <h5>Referral Commission</h5>
                        <%#Eval("Referral_Income","{0:N}") %>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="Comission">
                        <h5>Generation Commission</h5>
                        <%#Eval("Generation_Income","{0:N}") %>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="Comission">
                        <h5>Retail Commission</h5>
                        <%#Eval("Instant_Cash_Back_Income","{0:N}") %>
                    </div>
                </div>
            </div>
            
            <h3>Send & received balance</h3>

            <div class="row">
                <div class="col-sm-4">
                    <div class="white-box">
                        <h2 class="box-title">
                            <i class="fa fa-arrow-circle-up" aria-hidden="true"></i>
                            Withdraw Balance
                        </h2>
                        <ul class="list-inline two-part">
                            <li>
                                <i class="fa fa-money b-color" aria-hidden="true"></i>
                            </li>
                            <li class="text-right b-color">
                                <span><%#Eval("Withdraw_Balance","{0:N}") %></span>
                            </li>
                        </ul>
                    </div>
                </div>

                <div class="col-sm-4">
                    <div class="white-box">
                        <h2 class="box-title">
                            <i class="fa fa-paper-plane" aria-hidden="true"></i>
                            Send Balance
                        </h2>
                        <ul class="list-inline two-part">
                            <li>
                                <i class="fa fa-money b-color" aria-hidden="true"></i>
                            </li>
                            <li class="text-right b-color">
                                <span><%#Eval("Send_Balance","{0:N}") %></span>
                            </li>
                        </ul>
                    </div>
                </div>

                <div class="col-sm-4">
                    <div class="white-box">
                        <h2 class="box-title">
                            <i class="fa fa-arrow-circle-down" aria-hidden="true"></i>
                            Received Balance
                        </h2>
                        <ul class="list-inline two-part">
                            <li>
                                <i class="fa fa-money b-color" aria-hidden="true"></i>
                            </li>
                            <li class="text-right b-color">
                                <span><%#Eval("Received__Balance","{0:N}") %></span>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </ItemTemplate>
    </asp:FormView>

    <asp:SqlDataSource ID="BonusSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Referral_Income, Generation_Income, Instant_Cash_Back_Income, Available_Balance, SignUpDate, Total_Amount, Withdraw_Balance, Send_Balance, Received__Balance FROM Member WHERE (MemberID = @MemberID)">
        <SelectParameters>
            <asp:QueryStringParameter Name="MemberID" QueryStringField="Member" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    
    
    <div class="Contain">
        <h3>Genealogy</h3>
        <div class="form-inline">
            <div class="form-group">
                <asp:TextBox ID="FindTextBox" runat="server" CssClass="form-control" placeholder="Find by Userid"></asp:TextBox>
            </div>
            <div class="form-group">
                <asp:Button ID="FindButton" runat="server" CssClass="btn btn-primary" Text="Find" OnClick="FindButton_Click" />
            </div>
        </div>

        <div class="table-responsive">
            <div class="alert alert-success">
                <asp:Label ID="Total_Label" runat="server" CssClass="Result_Msg"></asp:Label>
            </div>
            <asp:GridView ID="MembersGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataSourceID="MembersSQL" AllowPaging="True" AllowSorting="True" PageSize="50">
                <Columns>
                    <asp:HyperLinkField SortExpression="UserName" DataTextField="UserName" DataNavigateUrlFields="MemberID" DataNavigateUrlFormatString="MyAlliance_Details.aspx?Member={0}" HeaderText="Details" />
                    <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
                </Columns>
                <EmptyDataTemplate>
                    No Record
                </EmptyDataTemplate>
                <PagerStyle CssClass="pgr" />
            </asp:GridView>
            <asp:SqlDataSource ID="MembersSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Member.SignUpDate, Member.Is_Identified, Registration.UserName, Member.MemberID, Registration.Name FROM Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID WHERE (Member.Referral_MemberID = @Referral_MemberID) ORDER BY Member.SignUpDate DESC"
                FilterExpression="UserName LIKE '{0}%'" CancelSelectOnNullParameter="False">
                <FilterParameters>
                    <asp:ControlParameter ControlID="FindTextBox" Name="Find" PropertyName="Text" />
                </FilterParameters>
                <SelectParameters>
                    <asp:QueryStringParameter Name="Referral_MemberID" QueryStringField="Member" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>

        </div>
    </div>
</asp:Content>
