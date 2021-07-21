
{*******************************************************}
{                                                       }
{       Defined Stream Include File                     }
{                                                       }
{                                                       }
{       Copyright (c) 2000 Defined Systems Inc.         }
{                                                       }
{*******************************************************}

{.$DEFINE DEMO}

{--------------------- General Defines - DO NOT MODIFY ------------------------}

{$IFDEF VER80}                {Delphi 1.0}
  {$DEFINE D1}
{$ENDIF}

{$IFDEF VER90}                {Delphi 2.0}
  {$DEFINE D2}
{$ENDIF}

{$IFDEF VER93}                {C++ Builder 1.0}
  {$DEFINE CB1}
{$ENDIF}

{$IFDEF VER100}               {Delphi 3.0}
  {$DEFINE D3}
{$ENDIF}

{$IFDEF VER110}               {C++ Builder 3.0}
  {$DEFINE CB3}
  {$ObjExportAll On}
{$ENDIF}

{$IFDEF VER120}               {Delphi 4.0}
  {$DEFINE D4}
{$ENDIF}

{$IFDEF VER125}               {C++ Builder 4.0}
  {$DEFINE CB4}
  {$ObjExportAll On}
{$ENDIF}

{$IFDEF VER130}
  {$DEFINE D5}                {Delphi 5.0}
{$ENDIF}

{$IFDEF VER140}
  {$DEFINE D6}                {Delphi 6.0}
{$ENDIF}

{$IFDEF VER150}
  {$DEFINE D7}                {Delphi 7.0}
{$ENDIF}

{$IFDEF VER130}
  {$IFDEF BCB}
   {$DEFINE CB5}              {C++ Builder 5.0}
   {$ObjExportAll On}
  {$ENDIF}
{$ENDIF}

{$IFNDEF VER80}
 {$IFNDEF VER90}
  {$IFNDEF VER93}
   {$IFNDEF VER100}
    {$IFNDEF VER110}
     {$DEFINE D4_PLUS}         {Delphi 4.0 or higher}
     {$DEFINE CB4_PLUS}        {C++ Builder 4.0 or higher}
    {$ENDIF}
   {$ENDIF}
  {$ENDIF}
 {$ENDIF}
{$ENDIF}

{$IFNDEF VER80}
 {$IFNDEF VER90}
  {$IFNDEF VER93}
   {$IFNDEF VER100}
    {$IFNDEF VER110}
     {$IFNDEF VER120}
      {$IFNDEF VER125}
       {$DEFINE D5_PLUS}         {Delphi 5.0 or higher}
       {$DEFINE CB5_PLUS}        {C++ Builder 5.0 or higher}
      {$ENDIF}
     {$ENDIF}
    {$ENDIF}
   {$ENDIF}
  {$ENDIF}
 {$ENDIF}
{$ENDIF}

{$IFNDEF VER80}
 {$IFNDEF VER90}
  {$IFNDEF VER93}
   {$IFNDEF VER100}
    {$IFNDEF VER110}
     {$IFNDEF VER120}
      {$IFNDEF VER130}
        {$IFNDEF VER135}
         {$DEFINE D6_PLUS}         {Delphi 6.0 or higher}
        {$ENDIF}
      {$ENDIF}
     {$ENDIF}
    {$ENDIF}
   {$ENDIF}
  {$ENDIF}
 {$ENDIF}
{$ENDIF}


