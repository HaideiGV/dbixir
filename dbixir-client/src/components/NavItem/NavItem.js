import React, { Link, Component } from "react";
import "./NavItem";
import genUrl from "../../constants/domainUrl";

class NavItem extends Component {
    render () {
        return (
            <div>
                <span className="NavItem" >
                    <a href={ genUrl(this.props.navItemUrl) }>{ this.props.navItemName }</a>
                </span>
            </div>
        )
    }
};

export default NavItem;