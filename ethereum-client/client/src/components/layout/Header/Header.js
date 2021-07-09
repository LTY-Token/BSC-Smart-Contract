import React, { useState } from "react";
import { Modal } from "../index";
import { Contract } from "../index";

import "./Header.scss";

const Header = ({ tokenBalance, balance, addToken, address, info }) => {
  const [visible, setVisible] = useState(false);

  const showModal = () => {
    setVisible(true);
  };

  const closeModal = () => {
    setVisible(false);
  };

  console.log(address);

  return (
    <>
      <header className="app-header">
        <div className="container">
          <div className="app-header__info">
            <div className="balance">
              <p className="balance__title">Balance:</p>
              <div className="balance__item">
                <div className="balance__token">
                  <img src="/images/lty.svg" alt="lty" />
                  <span> LTY </span>
                </div>
                <div className="balance__price">{tokenBalance}</div>
              </div>
              <div className="balance__item">
                <div className="balance__token">
                  <img src="/images/eth.svg" alt="eth" />
                  <span> ETH </span>
                </div>
                <div className="balance__price">{balance}</div>
              </div>
            </div>
            <div className="app-header__contract">
              <button
                type="button"
                className="btn-secondary"
                onClick={showModal}
              >
                Contract details
              </button>
            </div>
          </div>
          <div className="app-header__btns">
            <button type="button" className="btn-secondary" onClick={addToken}>
              Add LTY to wallet
            </button>
            <div className="app-header__account">
              {`${address.substring(0, 6)}...${address.substring(
                address.length - 4
              )}`}
            </div>
          </div>
        </div>
      </header>
      {visible && (
        <Modal close={closeModal} title="Contract details:">
          <Contract info={info} />
        </Modal>
      )}
    </>
  );
};

export default Header;
