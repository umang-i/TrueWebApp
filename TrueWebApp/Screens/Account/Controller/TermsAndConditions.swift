//
//  TermsAndConditions.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 05/05/25.
//

import Foundation
import UIKit
import WebKit

enum PageType {
    case terms
    case privacy
}

class HTMLPageViewController: UIViewController, CustomNavBarDelegate, WKNavigationDelegate {

    var pageType: PageType = .terms

    private var webView: WKWebView!
    private var topBackgroundView: UIView!
    private var navBar: CustomNavBar!
    private var activityIndicator: UIActivityIndicatorView!
    private var whiteOverlayView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
        setupWhiteOverlay()
        setupWebView()
        setupActivityIndicator()
        fetchPageContent()
    }

    private func setupNavBar() {
        topBackgroundView = UIView()
        topBackgroundView.backgroundColor = .white
        topBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBackgroundView)

        navBar = CustomNavBar(text: pageType == .privacy ? "Privacy Policy" : "Terms of Service")
        navBar.delegate = self
        navBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBar)

        NSLayoutConstraint.activate([
            topBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            topBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBackgroundView.heightAnchor.constraint(equalToConstant: 100),

            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupWhiteOverlay() {
        whiteOverlayView = UIView()
        whiteOverlayView.backgroundColor = .white
        whiteOverlayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(whiteOverlayView)

        NSLayoutConstraint.activate([
            whiteOverlayView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            whiteOverlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            whiteOverlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            whiteOverlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupWebView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(webView, belowSubview: whiteOverlayView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }

    private func fetchPageContent() {
        activityIndicator.startAnimating()

        ApiService().fetchPageContent { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.activityIndicator.stopAnimating()

                switch result {
                case .success(let pageResponse):
                    var html: String = ""
                    switch self.pageType {
                    case .terms:
                        html = pageResponse.terms.pageContent
                    case .privacy:
                        html = pageResponse.privacy.pageContent
                    }

                    self.loadHTMLContent(html)

                case .failure(let error):
                    self.whiteOverlayView.isHidden = true
                    self.showError(message: error.localizedDescription)
                }
            }
        }
    }

    private func loadHTMLContent(_ htmlContent: String) {
        let viewportMetaTag = """
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=5, user-scalable=yes">
        """
        let html = "<head>\(viewportMetaTag)</head>" + htmlContent
        webView.loadHTMLString(html, baseURL: nil)
    }

    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Hide the white overlay when content is fully loaded
        UIView.animate(withDuration: 0.3) {
            self.whiteOverlayView.alpha = 0
        } completion: { _ in
            self.whiteOverlayView.isHidden = true
        }
    }

    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
