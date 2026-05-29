#pragma once

// protobuf
//
// NOTE: This fork pins protobuf to 3.21.12 (see vcpkg manifest), which is a
// self-contained build with no abseil or utf8_range dependencies. The abseil
// and utf8_range auto-link pragmas required by newer protobuf (22+/5.x) have
// been removed accordingly; those libraries are not present in the install
// tree and linking them produced LNK1104. If protobuf is ever bumped to a
// version that depends on abseil, restore the corresponding pragmas here.
#ifdef _DEBUG
    #pragma comment(lib, "libprotobufd")
#else
    #pragma comment(lib, "libprotobuf")
#endif
