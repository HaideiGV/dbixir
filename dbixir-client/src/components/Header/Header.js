import React, { Component } from "react";
import NavItem from "../NavItem/NavItem"
import apiPaths from "../../constants/apiUrls";

class Header extends Component {
    render () {
        return (
            <div className="NavItemList">
                <NavItem key="1" navItemName={"Main"} navItemUrl={ apiPaths.HOME_PAGE } />
                <NavItem key="2" navItemName={"Connect"} navItemUrl={ apiPaths.CONNECT_PAGE } />
                <NavItem key="3" navItemName={"Tables"} navItemUrl={ apiPaths.TABLES_PAGE } />
                <NavItem key="4" navItemName={"Query Builder"} navItemUrl={ apiPaths.QUERY_PAGE } />
            </div>
        )
    }
};

export default Header;