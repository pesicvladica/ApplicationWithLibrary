<h1>Motiv8 Library iOS Application</h1>

<p>This iOS application leverages the <code>Motiv8Library</code> framework to provide users with access to various device data fetchers, such as device information, contacts, images, and videos. The application allows users to collect and display this data without requiring an account, and it works exclusively on iOS 17 or higher.</p>

<h2>Features</h2>

<ul>
  <li><strong>Device Information</strong>: Fetch and display details about the device such as model, OS version, and more.</li>
  <li><strong>Contacts</strong>: Retrieve the user's contacts and display them in the application.</li>
  <li><strong>Images</strong>: Fetch metadata about images stored on the device and present them.</li>
  <li><strong>Videos</strong>: Fetch metadata about videos stored on the device and present them.</li>
</ul>

<h2>Requirements</h2>

<ul>
  <li>iOS 17 or higher</li>
  <li>Swift 5.0 or later</li>
</ul>

<h2>Setup</h2>

<p>To integrate the <code>Motiv8Library</code> in your iOS project, follow these steps:</p>

<ol>
  <li><strong>Install the Library</strong>: Ensure <code>Motiv8Library</code> is included in your project, either by adding it directly or via a package manager.</li>
  <li><strong>Initialization</strong>: The library can be initialized with a custom repository or use the default repository, which provides real data sources for contacts, images, videos, and device information.
    <pre><code>let library = Motiv8Library()</code></pre>
  </li>
  <li><strong>Using the Fetchers</strong>: You can access different fetchers for device data using the following properties:
    <ul>
      <li><code>infoFetcher</code>: Retrieves device-specific information.</li>
      <li><code>contactFetcher</code>: Fetches the user's contacts.</li>
      <li><code>imageFetcher</code>: Fetches metadata for device images.</li>
      <li><code>videoFetcher</code>: Fetches metadata for device videos.</li>
    </ul>
  </li>
</ol>

<h3>Example Usage</h3>

<p>Here’s how to use the <code>Motiv8Library</code> to fetch and display device contacts:</p>

<pre><code>let library = Motiv8Library()

library.contactFetcher.fetchNextPage { result in
    switch result {
    case .success(let contacts):
        print("Fetched contacts: \(contacts)")
    case .failure(let error):
        print("Error fetching contacts: \(error)")
    }
}</code></pre>

<h3>Fetchers</h3>

<ul>
  <li><strong>InfoFetcher</strong>: Collects device information.
    <pre><code>library.infoFetcher.collect { result in
        // Handle device info
    }</code></pre>
  </li>
  <li><strong>ContactFetcher</strong>: Collects user contacts.
    <pre><code>library.contactFetcher.fetchNextPage { result in
        // Handle contacts
    }</code></pre>
  </li>
  <li><strong>ImageFetcher</strong>: Collects metadata about device images.
    <pre><code>library.imageFetcher.prefetchAllItems { result in
        // Handle image metadata
    }</code></pre>
  </li>
  <li><strong>VideoFetcher</strong>: Collects metadata about device videos.
    <pre><code>library.videoFetcher.getNextPage { result in
        // Handle video metadata
    }</code></pre>
  </li>
</ul>

<h2>No Account Required</h2>

<p>No user account or authentication is required to access the data. All data is fetched locally from the device.</p>

<h2>License</h2>

<p>This project is licensed under the MIT License - see the <a href="https://mit-license.org/">LICENSE</a> file for details.</p>

<h2>Cloning the Repository</h2>

<p>To clone this project to your local machine, follow these steps:</p>

<ol>
  <li>Open your terminal.</li>
  <li>Run the following command to clone the repository:</li>
</ol>

<pre><code>git clone https://github.com/pesicvladica/ApplicationWithLibrary</code></pre>

<p>After cloning, navigate to the project directory and open the project file in Xcode:</p>

<pre><code>cd motiv8-library-ios
open Motiv8.xcworkspace</code></pre>
