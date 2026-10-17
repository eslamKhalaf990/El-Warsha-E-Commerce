/// Utility providing access to bundled Elwarsha product images from [warsha-images/].
/// Used as high quality fallback when remote product images fail to load or are missing.
class WarshaImages {
  static const String basePath = 'warsha-images';

  /// All 133 webp images available in the warsha-images directory.
  static const List<String> images = [
    '031a44dc-d0a9-4caf-8e74-0be162b081c8.webp',
    '03cd5b0e-aac1-448f-9818-d61da35f24cb.webp',
    '07a665b7-864e-4fa6-8c82-ae84f1532475.webp',
    '0803b713-d488-444c-92be-75a9de9346ff.webp',
    '09558a19-a1aa-48e0-9d4a-5439b0575364.webp',
    '0a650833-b7bf-49d9-b9c0-850c3abf9f5b.webp',
    '0aec96a1-ddb5-4a45-888f-c7ffc7534589.webp',
    '0bcf1d32-646f-40e5-ab16-1639cbecd802.webp',
    '0d0c92a9-2ad4-4f06-9a9b-e50db60b09c4.webp',
    '0d87e9e9-2653-48aa-a134-4c886fc923ba.webp',
    '0ecb3f46-c836-4a12-90cb-2bee252d4396.webp',
    '12a046dd-eab3-4880-b159-d4c37fb90813.webp',
    '1aac231c-69a1-4596-8942-4c9de5d1ee02.webp',
    '1cf80b63-5077-467d-84db-71e6cf1e363a.webp',
    '1e79ada1-c22b-45d2-8c8d-8e4da32e4330.webp',
    '1f308255-9f88-4c7a-a445-2443db881343.webp',
    '2267ba6c-ad00-4eb5-9a05-bebb28037963.webp',
    '2438dd41-4128-49b8-a337-c3595e789afa.webp',
    '271241c4-ffeb-4d12-a021-44d3ee230c0c.webp',
    '2917fff7-2198-414a-8753-e765bca04009.webp',
    '296bb2e8-635c-41de-b053-42297f6ff679.webp',
    '2b324526-d9bd-4c0e-997c-c78263c7a6ba.webp',
    '2de4f730-86df-44d7-a6a3-0a89b1328920.webp',
    '314c6463-89fa-400a-89f0-727b89dd2d02.webp',
    '3194ba28-88ac-4bdf-a0ed-fac372455fb7.webp',
    '3448eb60-f085-4a6b-aa58-8a8e3fd00e04.webp',
    '34729335-b6d1-47e9-9318-57cf20516522.webp',
    '354271fe-848b-4965-a897-ae8e394a4ee6.webp',
    '38371096-3b04-471a-9ea1-fc99b4fb2adb.webp',
    '4426df5d-72f1-4834-a809-451bfd3e0325.webp',
    '466b716a-c1be-45cd-9617-1467ed3f7354.webp',
    '47a44931-5837-445c-b20e-356f2c1615fc.webp',
    '49fc6832-feae-4263-830a-b563660c8e51.webp',
    '4a173a1c-e1d8-4896-8db0-c5e458bc42bf.webp',
    '4a6741bd-a73f-487f-ba3c-6e375797add9.webp',
    '4ec32700-8114-427b-87e2-5cd27dcbcc57.webp',
    '50f2cbbb-76bf-4edf-aefa-bd3c77fb30af.webp',
    '52cc91e6-51f1-437a-a97c-b9f89faa775c.webp',
    '5315ad73-e85a-4c01-8d47-509bd57049a0.webp',
    '5415aba7-0aad-4a1b-a55a-cf32a31702d2.webp',
    '555a87ae-c01c-4aa3-a5bd-7fac2fa4cb73.webp',
    '5641afa1-2a14-494d-b539-e566c8797dd4.webp',
    '5a7b0212-52d4-450b-81f8-9db74d57be4b.webp',
    '5b66e639-a85e-47f7-953a-9c34ef92983d.webp',
    '5ec6921d-2b17-424c-8884-9d77b49df2a0.webp',
    '63587a8c-d935-4736-9c49-1dc47aabe17c.webp',
    '65b62818-0c7c-416c-b896-ad0c89849036.webp',
    '668ccbc8-1fa1-49bf-9d29-665deb59a081.webp',
    '6ccbb70c-ba14-4806-988d-5f3845b30788.webp',
    '73194fb9-9d70-415c-9896-8ab21a3e20eb.webp',
    '73aa8346-a6c0-47dc-a66e-85957b3d7d6d.webp',
    '778a01f1-578d-4473-b1bc-778f5644f14f.webp',
    '7b687c2e-2ee9-4f0d-bf07-425d65c9f269.webp',
    '7bdf8276-2d43-4c88-8958-17316aea5655.webp',
    '7cba5b1d-c908-4088-87ee-39d20c913e56.webp',
    '7d37b175-0899-4e5e-beb5-8404d3b62b84.webp',
    '7e4a7bdd-89ed-4161-bab0-081de0fd9c18.webp',
    '80179006-81fb-4bf2-b236-b7e912080266.webp',
    '80dbd015-e75c-4777-a56d-72f167d9fcde.webp',
    '8230e1f6-5394-4e00-887f-2f1595e0135b.webp',
    '83eff743-3e20-4d9b-914b-8172e22a5eb3.webp',
    '86b27c91-96f2-4aca-82f1-b06565d88b3f.webp',
    '8718d32d-85b0-48cb-b8c2-0b9cc542e91b.webp',
    '8a1a2a2e-00cc-467e-b463-e34d91ff41dc.webp',
    '8d314f90-6ae4-43ef-8400-62591e7531b8.webp',
    '8d98892b-3b4c-41ba-8a42-7b761d0a80c5.webp',
    '8f465c59-5376-4cb2-9465-c061b3e01bc6.webp',
    '90f01af4-1d83-45dd-b2a3-4032112977df.webp',
    '91979ed9-3f5c-4cc1-97f6-d48e005bb9f7.webp',
    '91d9dd1d-8c09-4419-90c4-127271ee78e7.webp',
    '9373cb7c-39c3-4032-b2ba-85d18cabaa55.webp',
    '9473260e-e08d-4152-9b2a-698cf7da5dc7.webp',
    '974d16e8-25ff-49f8-b0df-58f11a912905.webp',
    '983c0512-8db6-4f8a-95d3-f6fa1b378f12.webp',
    '9b9daa1f-c876-4a8e-9ba6-c07bca13f110.webp',
    '9d029e5b-2be4-4972-98ef-94887f4d87ea.webp',
    'a2c24c25-8364-4f12-95f8-38a96c1801ea.webp',
    'a5ba1021-b0d8-4496-a906-916343dea0a6.webp',
    'a8fe8f20-c209-485e-9366-70eb6c2c6c35.webp',
    'a935a004-71be-4e46-b998-c6186bf17136.webp',
    'ae3612e1-326c-4d08-aa0d-75b14354055a.webp',
    'ae9b889c-33b0-435b-902c-e59c343b93a2.webp',
    'aea0ae80-2ae9-4207-a0c6-1d1b0f3b8ef9.webp',
    'b357275b-7f19-49a7-bddb-41c4f8e927cd.webp',
    'b43df7b4-190a-4f40-bf8f-19ddf707056e.webp',
    'b4f1eb34-1e42-4d3e-9d94-a9ffcb466782.webp',
    'b679f441-f4ed-40f5-b387-b1679add6fcd.webp',
    'b7eee595-35a0-4059-bb8b-326096809847.webp',
    'b9afb90b-e16e-42a8-9f82-0c8d36303fc1.webp',
    'be9d3a3c-4cfb-4502-81bb-d433f5b25335.webp',
    'bf96bb79-161a-48d2-b17d-f9d0e706a16f.webp',
    'c012b018-7ca2-41a6-be40-4b96d47f770e.webp',
    'c1914315-fc44-42e9-9cd3-ef9aa08c9775.webp',
    'c1ff683e-a242-479e-a8cc-0903b7e1c9ac.webp',
    'c4d3ac25-7006-455b-8adb-b4e43ce99915.webp',
    'cc13f8d0-8df8-45e8-af18-1d2de720a740.webp',
    'cc72c24a-27f2-43c8-ae7b-dcc43013e071.webp',
    'cf322b2e-5af5-40cf-966e-e4e934a9240b.webp',
    'd00e0f65-e03b-4a10-b6da-6eb874c1a890.webp',
    'd0726f5e-5d12-49ee-b1fd-1d8df76a3ec8.webp',
    'd247d026-4655-44a8-8a1b-f0e94df5949a.webp',
    'd2a409ef-3979-4c3f-b1f0-8e15ac23913a.webp',
    'd2d733ab-9173-41bf-a40a-82a7778f1131.webp',
    'd421815a-67df-4e6d-bffa-c5d249cd62eb.webp',
    'd8054f5f-3ca9-485c-8803-8f8a57160c13.webp',
    'd87769f7-00f2-429c-baac-6b8cfb93de29.webp',
    'd8e531c2-c3f5-4e6b-a0e0-8349afe3ff35.webp',
    'defc4af8-7e3a-4717-939c-b24685cb620a.webp',
    'e150b5fd-1125-4222-8acc-b90f5cc38ad0.webp',
    'e1985271-d151-4991-8331-d9adb2553237.webp',
    'e1e7e08a-d8a7-41ca-ae09-258152d42509.webp',
    'e2d8791a-9db1-4fd4-8a15-f5acbea05427.webp',
    'e4052fc3-4c37-45d9-acdd-8040e7565df9.webp',
    'e417f6d4-8556-4872-afce-e4ec74a49092.webp',
    'e7473af5-73ce-4346-beb7-dada006ce690.webp',
    'e814222b-b2b8-4447-986d-cd1556e416b4.webp',
    'e9dfed6f-494a-47e8-a362-a2797b41b1b5.webp',
    'ea6c6409-ae2d-41b6-94d1-994703222f0d.webp',
    'eb4f9dc6-abcc-460e-8137-1dbeb5fcb2f0.webp',
    'ee3b886c-b6c6-4111-8064-2b9d5d72e909.webp',
    'f1158f4b-dd55-4100-8183-e1bc0ed85c51.webp',
    'f1b66a5d-c43d-4cfe-a35a-eb372e3577fa.webp',
    'f2501f57-d845-42a5-a944-595ecae54378.webp',
    'f5a9129a-563c-4afd-aa36-e36053508665.webp',
    'f8e9903e-e622-4ec2-9b0e-4275c8a9a1e6.webp',
    'fa959620-4387-4b3c-b4ad-669bdf710db2.webp',
    'fac69cbd-452a-42be-a0ae-177b0148bb93.webp',
    'fb0b5e27-b7ef-4e29-8120-1274e31ef6c6.webp',
    'fba6a9a3-6d07-4928-892c-b3e35dd4b7cd.webp',
    'fe8b5108-f77e-4d1f-8d6c-8aac119bb08d.webp',
    'ff409fa4-d2c2-404a-b334-0f21d353d289.webp',
    'upload(1).webp',
    'upload.webp'
  ];

  /// Returns the asset path for a fallback image.
  ///
  /// If [seed] (e.g. product ID) is provided, deterministically returns an image
  /// so that the same product consistently displays the same fallback image.
  /// If [key] (e.g. imageUrl) is provided, uses its hash code as seed.
  /// Falls back to the first image if neither is provided.
  static String getFallbackImage({int? seed, String? key}) {
    if (images.isEmpty) return '';
    int index = 0;
    if (seed != null) {
      index = seed.abs() % images.length;
    } else if (key != null && key.isNotEmpty) {
      index = key.hashCode.abs() % images.length;
    }
    return "$basePath/${images[index]}";
  }

  /// Helper to get a deterministic asset path for a product.
  static String forProduct({int? id, String? imageUrl}) {
    return getFallbackImage(seed: id, key: imageUrl);
  }
}
